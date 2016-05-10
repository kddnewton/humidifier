module Humidifier
  module AwsAdapters
    class SDKV1 < Base

      def stack_exists?(stack, _ = {})
        base_module::CloudFormation::Stack.new(stack.name).exists?
      end

      private

      def base_module
        AWS
      end
    end
  end
end
