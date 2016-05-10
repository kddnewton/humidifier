module Humidifier
  module AwsAdapters
    class Base

      def create_stack(stack)
        try_valid { client.create_stack(stack_name: stack.name, template_body: stack.to_cf) }
      end

      def delete_stack(stack)
        client.delete_stack(stack_name: stack.name)
        true
      end

      def deploy_stack(stack)
        stack_exists?(stack) ? update_stack(stack) : create_stack(stack)
      end

      def stack_exists?(stack)
        base_module::CloudFormation.stacks[stack.name].exists?
      end

      def update_stack(stack)
        try_valid { client.update_stack(stack_name: stack.name, template_body: stack.to_cf) }
      end

      def validate_stack(stack)
        try_valid { client.validate_template(template_body: stack.to_cf) }
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
