module Humidifier
  module AwsAdapters
    class SDKV1 < Base

      private

      def base_module
        AWS
      end
    end
  end
end
