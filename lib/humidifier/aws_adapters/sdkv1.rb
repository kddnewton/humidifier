module Humidifier
  module AwsAdapters
    class SDKV1 < Base

      def stack_exists?(stack)
        client.stacks[stack.name].exists?
      end

      private

      def base_module
        AWS
      end
    end
  end
end
