module Humidifier
  module AwsAdapters

    # Validate using v2 of the aws-sdk
    class SDKV2
      def validate_stack(stack)
        Aws::CloudFormation::Client.new(region: AwsShim::REGION).validate_template(template_body: stack.to_cf)
        true
      rescue Aws::CloudFormation::Errors::ValidationError
        false
      end
    end
  end
end
