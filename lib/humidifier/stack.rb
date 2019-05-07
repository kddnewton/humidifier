# frozen_string_literal: true

module Humidifier
  # Represents a CFN stack
  class Stack
    class TemplateTooLargeError < StandardError
      def initialize(bytesize)
        super(
          "Cannot use a template > #{MAX_TEMPLATE_URL_SIZE} bytes " \
          "(currently #{bytesize} bytes), consider using nested stacks " \
          '(http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide' \
          '/aws-properties-stack.html)'
        )
      end
    end

    # The maximum size a template body can be before it has to be put somewhere
    # and referenced through a URL
    MAX_TEMPLATE_BODY_SIZE = 51_200

    # The maximum size a template body can be inside of an S3 bucket
    MAX_TEMPLATE_URL_SIZE = 460_800

    # The maximum amount of time that Humidifier should wait for a stack to
    # complete a CRUD operation
    MAX_WAIT = 600

    # The AWS region, can be set through the environment, defaults to us-east-1
    REGION = ENV['AWS_REGION'] || 'us-east-1'

    # Format of the timestamp used in changeset naming
    TIME_FORMAT = '%Y-%m-%d-%H-%M-%S'

    # Single settings on the stack
    STATIC_RESOURCES =
      Utils.underscored(%w[AWSTemplateFormatVersion Description Metadata])

    # Lists of objects linked to the stack
    ENUMERABLE_RESOURCES =
      Utils.underscored(%w[Conditions Mappings Outputs Parameters Resources])

    attr_accessor :id
    attr_reader(:name, *ENUMERABLE_RESOURCES.values, *STATIC_RESOURCES.values)

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

    def identifier
      id || name || default_identifier
    end

    def to_cf(serializer = :json)
      resources = static_resources.merge(enumerable_resources)

      case serializer
      when :json then JSON.pretty_generate(resources)
      when :yaml then YAML.dump(resources)
      end
    end

    def create(opts = {})
      params = { stack_name: name }
      params.merge!(template_param_for(opts)).merge!(opts)

      try_valid do
        client.create_stack(params).tap { |response| @id = response.stack_id }
      end
    end

    def create_and_wait(opts = {})
      perform_and_wait(:create, opts)
    end

    def create_change_set(opts = {})
      params = {
        stack_name: identifier,
        change_set_name: "changeset-#{Time.now.strftime(TIME_FORMAT)}"
      }
      params.merge!(template_param_for(opts)).merge!(opts)

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
      params = { stack_name: identifier }
      params.merge!(template_param_for(opts)).merge!(opts)

      try_valid { client.update_stack(params) }
    end

    def update_and_wait(opts = {})
      perform_and_wait(:update, opts)
    end

    def upload
      Humidifier.config.ensure_upload_configured!(identifier)
      upload_object("#{Humidifier.config.s3_prefix}#{identifier}.json")
    end

    def valid?(opts = {})
      params = template_param_for(opts).merge!(opts)

      try_valid { client.validate_template(params) }
    end

    def self.next_default_identifier
      @count ||= 0
      @count += 1
      "humidifier-stack-template-#{@count}"
    end

    private

    attr_reader :default_identifier

    def client
      @client ||= Aws::CloudFormation::Client.new(region: REGION)
    end

    def perform_and_wait(method, opts)
      public_send(method, opts).tap do |response|
        signal = :"stack_#{method}_complete"

        client.wait_until(signal, stack_name: identifier) do |waiter|
          waiter.max_attempts = (opts.delete(:max_wait) || MAX_WAIT) / 5
          waiter.delay = 5
        end
      end
    end

    def try_valid
      yield || true
    rescue Aws::CloudFormation::Errors::ValidationError => error
      warn(error.message)
      warn(error.backtrace)
      false
    end

    def upload_object(key)
      Aws.config.update(region: REGION)
      bucket = Humidifier.config.s3_bucket

      Aws::S3::Client.new.put_object(body: to_cf, bucket: bucket, key: key)
      Aws::S3::Object.new(bucket, key).presigned_url(:get)
    end

    def enumerable_resources
      ENUMERABLE_RESOURCES.each_with_object({}) do |(name, prop), list|
        resources = public_send(prop)
        next if resources.empty?

        list[name] =
          resources.map do |resource_name, resource|
            [resource_name, resource.to_cf]
          end.to_h
      end
    end

    def static_resources
      STATIC_RESOURCES.each_with_object({}) do |(name, prop), list|
        resource = public_send(prop)
        list[name] = resource if resource
      end
    end

    def bytesize
      to_cf.bytesize.tap do |size|
        raise TemplateTooLargeError, size if size > MAX_TEMPLATE_URL_SIZE
      end
    end

    def template_param_for(opts)
      @template_param ||=
        begin
          if opts.delete(:force_upload) || Humidifier.config.force_upload || bytesize > MAX_TEMPLATE_BODY_SIZE
            { template_url: upload }
          else
            { template_body: to_cf }
          end
        end
    end
  end
end
