# frozen_string_literal: true

module Humidifier
  # Represents a CFN stack
  class Stack
    class NoResourcesError < Error
      def initialize(stack, action)
        super("Refusing to #{action} stack #{stack.name} with no resources")
      end
    end

    class TemplateTooLargeError < Error
      def initialize(bytesize)
        super(
          "Cannot use a template > #{MAX_TEMPLATE_URL_SIZE} bytes " \
          "(currently #{bytesize} bytes), consider using nested stacks " \
          "(http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide" \
          "/aws-properties-stack.html)"
        )
      end
    end

    class UploadNotConfiguredError < Error
      def initialize(identifier)
        super(<<~MSG)
          The #{identifier} stack's body is too large to be use the
          template_body option, and therefore must use the template_url option
          instead. You can configure Humidifier to do this automatically by
          setting up the s3 config on the top-level Humidifier object like so:

              Humidifier.configure do |config|
                config.s3_bucket = 'my.s3.bucket'
                config.s3_prefix = 'my-prefix/' # optional
              end
        MSG
      end
    end

    # The AWS region, can be set through the environment, defaults to us-east-1
    AWS_REGION = ENV.fetch("AWS_REGION", "us-east-1")

    # Lists of objects linked to the stack
    ENUMERABLE_RESOURCES =
      Humidifier.underscore(
        %w[Conditions Mappings Outputs Parameters Resources]
      )

    # The maximum size a template body can be before it has to be put somewhere
    # and referenced through a URL
    MAX_TEMPLATE_BODY_SIZE = 51_200

    # The maximum size a template body can be inside of an S3 bucket
    MAX_TEMPLATE_URL_SIZE = 460_800

    # The maximum amount of time that Humidifier should wait for a stack to
    # complete a CRUD operation
    MAX_WAIT = 600

    # Single settings on the stack
    STATIC_RESOURCES =
      Humidifier.underscore(%w[AWSTemplateFormatVersion Description Metadata])

    attr_accessor :id
    attr_writer :client

    attr_reader :name, *ENUMERABLE_RESOURCES.values, *STATIC_RESOURCES.values

    def initialize(opts = {})
      @name = opts[:name]
      @id = opts[:id]
      @default_identifier = self.class.next_default_identifier

      ENUMERABLE_RESOURCES.each_value do |property|
        instance_variable_set(:"@#{property}", opts.fetch(property, {}))
      end

      STATIC_RESOURCES.each_value do |property|
        instance_variable_set(:"@#{property}", opts[property])
      end
    end

    def add(name, resource, attributes = {})
      resources[name] = resource
      resource.update_attributes(attributes) if attributes.any?
      resource
    end

    def add_condition(name, opts = {})
      conditions[name] = Condition.new(opts)
    end

    def add_mapping(name, opts = {})
      mappings[name] = Mapping.new(opts)
    end

    def add_output(name, opts = {})
      outputs[name] = Output.new(opts)
    end

    def add_parameter(name, opts = {})
      parameters[name] = Parameter.new(opts)
    end

    def client
      @client ||= Aws::CloudFormation::Client.new(region: AWS_REGION)
    end

    def identifier
      id || name || default_identifier
    end

    def to_cf(serializer = :json)
      resources = static_resources.merge!(enumerable_resources)

      case serializer
      when :json then JSON.pretty_generate(resources)
      when :yaml then YAML.dump(resources)
      end
    end

    def create(opts = {})
      params = { stack_name: name }.merge!(template_for(opts)).merge!(opts)

      try_valid do
        client.create_stack(params).tap { |response| @id = response.stack_id }
      end
    end

    def create_and_wait(opts = {})
      perform_and_wait(:create, opts)
    end

    def create_change_set(opts = {})
      raise NoResourcesError.new(self, :change) unless resources.any?

      params = {
        stack_name: identifier,
        change_set_name: "changeset-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"
      }
      params.merge!(template_for(opts)).merge!(opts)

      try_valid { client.create_change_set(params) }
    end

    def delete(opts = {})
      client.delete_stack({ stack_name: identifier }.merge!(opts))
      true
    end

    def delete_and_wait(opts = {})
      perform_and_wait(:delete, opts)
    end

    def deploy(opts = {})
      raise NoResourcesError.new(self, :deploy) unless resources.any?

      exists? ? update(opts) : create(opts)
    end

    def deploy_and_wait(opts = {})
      perform_and_wait(exists? ? :update : :create, opts)
    end

    def deploy_change_set(opts = {})
      exists? ? create_change_set(opts) : create(opts)
    end

    def exists?
      Aws::CloudFormation::Stack.new(name: identifier).exists?
    end

    def update(opts = {})
      params = {
        capabilities: %w[CAPABILITY_IAM CAPABILITY_NAMED_IAM],
        stack_name: identifier
      }

      params.merge!(template_for(opts)).merge!(opts)

      try_valid { client.update_stack(params) }
    end

    def update_and_wait(opts = {})
      perform_and_wait(:update, opts)
    end

    def upload
      raise NoResourcesError.new(self, :upload) unless resources.any?

      bucket = Humidifier.config.s3_bucket
      raise UploadNotConfiguredError, identifier unless bucket

      Aws.config.update(region: AWS_REGION)
      key = "#{Humidifier.config.s3_prefix}#{identifier}.json"

      Aws::S3::Client.new.put_object(body: to_cf, bucket: bucket, key: key)
      Aws::S3::Object.new(bucket, key).presigned_url(:get)
    end

    def valid?(opts = {})
      params = template_for(opts).merge!(opts)

      try_valid { client.validate_template(params) }
    rescue Aws::CloudFormation::Errors::AccessDenied
      raise Error, <<~MSG
        The authenticated AWS profile does not have the requisite permissions
        to run this command. Ensure the profile has the
        "cloudformation:ValidateTemplate" IAM permission.
      MSG
    end

    def self.next_default_identifier
      @count ||= 0
      @count += 1
      "humidifier-stack-template-#{@count}"
    end

    private

    attr_reader :default_identifier

    def bytesize
      to_cf.bytesize.tap do |size|
        raise TemplateTooLargeError, size if size > MAX_TEMPLATE_URL_SIZE
      end
    end

    def enumerable_resources
      ENUMERABLE_RESOURCES.each_with_object({}) do |(name, prop), list|
        resources = public_send(prop)
        next if resources.empty?

        list[name] =
          resources.to_h do |resource_name, resource|
            [resource_name, resource.to_cf]
          end
      end
    end

    def perform_and_wait(method, opts)
      public_send(method, opts).tap do
        signal = :"stack_#{method}_complete"

        client.wait_until(signal, stack_name: identifier) do |waiter|
          waiter.max_attempts = (opts.delete(:max_wait) || MAX_WAIT) / 5
          waiter.delay = 5
        end
      end
    end

    def static_resources
      STATIC_RESOURCES.each_with_object({}) do |(name, prop), list|
        resource = public_send(prop)
        list[name] = resource if resource
      end
    end

    def template_for(opts)
      @template ||=
        if opts.delete(:force_upload) ||
           Humidifier.config.force_upload ||
           bytesize > MAX_TEMPLATE_BODY_SIZE

          { template_url: upload }
        else
          { template_body: to_cf }
        end
    end

    def try_valid
      yield || true
    rescue Aws::CloudFormation::Errors::ValidationError => error
      warn(error.message)
      warn(error.backtrace)
      false
    end
  end
end
