module Humidifier
  module AwsAdapters
    class SDKV2 < Base

      def stack_exists?(stack, _ = {})
        base_module::CloudFormation::Stack.new(name: stack.name).exists?
      end

      private

      def base_module
        Aws
      end
    end
  end
end
