# frozen_string_literal: true

module Humidifier
  # Represents a CFN stack
  class Stack
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

    # Add a resource to the stack and optionally set its attributes
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

    # The identifier used to find the stack in CFN, prefers id to name
    def identifier
      id || name || default_identifier
    end

    # A string representation of the stack that's valid for CFN
    def to_cf(serializer = :json)
      resources = static_resources.merge(enumerable_resources)

      case serializer
      when :json then JSON.pretty_generate(resources)
      when :yaml then YAML.dump(resources)
      end
    end

    # Create a CFN stack
    def create(payload)
      try_valid do
        response = client.create_stack(payload.create_params)
        payload.id = response.stack_id
        response
      end
    end

    # Create a change set in CFN
    def create_change_set(payload)
      change_set_name = "changeset-#{Time.now.strftime(TIME_FORMAT)}"
      payload.merge(change_set_name: change_set_name)
      try_valid { client.create_change_set(payload.create_change_set_params) }
    end

    # Delete a CFN stack
    def delete(payload)
      client.delete_stack(payload.delete_params)
      true
    end

    # Update a CFN stack if it exists, otherwise create it
    def deploy(payload)
      exists?(payload) ? update(payload) : create(payload)
    end

    # Create a change set if the stack exists, otherwise create the stack
    def deploy_change_set(payload)
      exists?(payload) ? create_change_set(payload) : create(payload)
    end

    # True if the stack exists in CFN
    def exists?(payload)
      Aws::CloudFormation::Stack.new(name: payload.identifier).exists?
    end

    # Update a CFN stack
    def update(payload)
      try_valid { client.update_stack(payload.update_params) }
    end

    # Upload a CFN stack to S3 so that it can be referenced via template_url
    def upload(payload)
      Humidifier.config.ensure_upload_configured!(payload)
      filename = "#{Humidifier.config.s3_prefix}#{payload.identifier}.json"
      upload_object(payload, filename)
    end

    # Validate a template in CFN
    def valid?(payload)
      try_valid { client.validate_template(payload.validate_params) }
    end

    %i[create delete deploy update].each do |method|
      define_method(:"#{method}_and_wait") do |payload|
        perform_and_wait(method, payload)
      end
    end

    # Increment the default identifier
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

    def perform_and_wait(method, payload)
      method = exists?(payload) ? :update : :create if method == :deploy
      response = public_send(method, payload)
      signal = :"stack_#{method}_complete"

      client.wait_until(signal, stack_name: payload.identifier) do |waiter|
        waiter.max_attempts = payload.max_wait / 5
        waiter.delay = 5
      end

      response
    end

    def try_valid
      yield || true
    rescue Aws::CloudFormation::Errors::ValidationError => error
      warn(error.message)
      warn(error.backtrace)
      false
    end

    def upload_object(payload, key)
      Aws.config.update(region: REGION)
      @s3_client ||= Aws::S3::Client.new

      @s3_client.put_object(
        body: payload.template_body,
        bucket: Humidifier.config.s3_bucket,
        key: key
      )

      object = Aws::S3::Object.new(Humidifier.config.s3_bucket, key)
      object.presigned_url(:get)
    end

    def enumerable_resources
      ENUMERABLE_RESOURCES.each_with_object({}) do |(name, prop), list|
        resources = send(prop)
        next if resources.empty?

        list[name] =
          resources.map do |resource_name, resource|
            [resource_name, resource.to_cf]
          end.to_h
      end
    end

    def static_resources
      STATIC_RESOURCES.each_with_object({}) do |(name, prop), list|
        resource = send(prop)
        list[name] = resource if resource
      end
    end
  end
end
