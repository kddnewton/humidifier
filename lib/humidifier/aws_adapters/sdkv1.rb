module Humidifier
  module AwsAdapters

    # Validate using v1 of the aws-sdk
    class SDKV1
      def validate_stack(stack)
        AWS::CloudFormation::Client.new(region: AwsShim::REGION).validate_template(template_body: stack.to_cf)
        true
      rescue AWS::CloudFormation::Errors::ValidationError
        false
      end
    end
  end
end
