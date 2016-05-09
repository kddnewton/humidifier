module Humidifier
  module AwsAdapters

    # Validate using v1 of the aws-sdk
    class SDKV1
      def create_stack(stack)
        try_valid { client.create_template(stack_name: stack.name, template_body: stack.to_cf) }
      end

      def validate_stack(stack)
        try_valid { client.validate_template(template_body: stack.to_cf) }
      end

      private

      def client
        @client ||= AWS::CloudFormation::Client.new(region: AwsShim::REGION)
      end

      def try_valid
        yield
        true
      rescue AWS::CloudFormation::Errors::ValidationError
        false
      end
    end
  end
end
