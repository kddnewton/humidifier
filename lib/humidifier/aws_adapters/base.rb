module Humidifier
  module AwsAdapters
    class Base

      def create_stack(stack, options = {})
        try_valid do
          response = client.create_stack({ stack_name: stack.name, template_body: stack.to_cf }.merge(options))
          stack.id = response.stack_id
          response
        end
      end

      def delete_stack(stack, options = {})
        client.delete_stack({ stack_name: stack.identifier }.merge(options))
        true
      end

      def deploy_stack(stack, options = {})
        stack_exists?(stack) ? update_stack(stack, options) : create_stack(stack, options)
      end

      def update_stack(stack, options = {})
        try_valid do
          client.update_stack({ stack_name: stack.identifier, template_body: stack.to_cf }.merge(options))
        end
      end

      def validate_stack(stack, options = {})
        try_valid { client.validate_template({ template_body: stack.to_cf }.merge(options)) }
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
