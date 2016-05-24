module Humidifier
  module AwsAdapters

    # The parent class for the adapters for both versions of the SDK
    class Base

      # Create a CFN stack
      def create(payload)
        try_valid do
          params = { stack_name: payload.name, template_body: payload.to_cf }.merge(payload.options)
          response = client.create_stack(params)
          payload.id = response.stack_id
          response
        end
      end

      # Delete a CFN stack
      def delete(payload)
        client.delete_stack({ stack_name: payload.identifier }.merge(payload.options))
        true
      end

      # Update a CFN stack if it exists, otherwise create it
      def deploy(payload)
        exists?(payload) ? update(payload) : create(payload)
      end

      # Update a CFN stack
      def update(payload)
        try_valid do
          params = { stack_name: payload.identifier, template_body: payload.to_cf }.merge(payload.options)
          client.update_stack(params)
        end
      end

      # Validate a template in CFN
      def valid?(payload)
        try_valid { client.validate_template({ template_body: payload.to_cf }.merge(payload.options)) }
      end

      %i[create delete deploy update].each do |method|
        define_method(:"#{method}_and_wait") do |payload|
          perform_and_wait(method, payload)
        end
      end

      private

      def client
        @client ||= base_module::CloudFormation::Client.new(region: AwsShim::REGION)
      end

      def try_valid
        yield || true
      rescue base_module::CloudFormation::Errors::ValidationError => error
        $stderr.puts error.message
        $stderr.puts error.backtrace
        false
      end
    end
  end
end
