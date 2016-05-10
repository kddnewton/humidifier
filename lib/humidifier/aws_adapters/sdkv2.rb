module Humidifier
  module AwsAdapters
    class SDKV2 < Base

      private

      def base_module
        Aws
      end
    end
  end
end
