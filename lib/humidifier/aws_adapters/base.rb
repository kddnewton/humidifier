# frozen_string_literal: true

module Humidifier
  # A container module for all adapters for the SDK
  module AwsAdapters
    # The parent class for the adapters for both versions of the SDK
    class Base
      # Create a CFN stack
      def create(payload)
        try_valid do
          response = client.create_stack(payload.create_params)
          payload.id = response.stack_id
          response
        end
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

      private

      def client
        @client ||=
          base_module::CloudFormation::Client.new(region: AwsShim::REGION)
      end

      def try_valid
        yield || true
      rescue base_module::CloudFormation::Errors::ValidationError => error
        warn(error.message)
        warn(error.backtrace)
        false
      end
    end
  end
end
