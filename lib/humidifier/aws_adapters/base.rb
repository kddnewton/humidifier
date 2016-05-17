module Humidifier
  module AwsAdapters
    class Base

      MAX_WAIT = 180

      def create(stack, options = {})
        try_valid do
          response = client.create_stack({ stack_name: stack.name, template_body: stack.to_cf }.merge(options))
          stack.id = response.stack_id
          response
        end
      end

      def delete(stack, options = {})
        client.delete_stack({ stack_name: stack.identifier }.merge(options))
        true
      end

      def deploy(stack, options = {})
        exists?(stack) ? update(stack, options) : create(stack, options)
      end

      def update(stack, options = {})
        try_valid do
          client.update_stack({ stack_name: stack.identifier, template_body: stack.to_cf }.merge(options))
        end
      end

      def valid?(stack, options = {})
        try_valid { client.validate_template({ template_body: stack.to_cf }.merge(options)) }
      end

      %i[create delete deploy update].each do |method|
        define_method(:"#{method}_and_wait") do |stack, options = {}|
          perform_and_wait(method, stack, options)
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
