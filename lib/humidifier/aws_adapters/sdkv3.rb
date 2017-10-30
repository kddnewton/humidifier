module Humidifier
  module AwsAdapters
    # The adapter for v3 of aws-sdk
    class SDKV3 < SDKV2
      # The notice to add the `aws-sdk-s3` gem when it is needed.
      S3_SDK_MESSAGE = <<-MSG.freeze
The AWS SDK for versions 3+ have broken out individual AWS modules into their
own gems. Since the stack that you're attempting to use is large enough that it
needs to be uploaded to S3, humidifier needs to load the S3 SDK. Please make
sure that the 'aws-sdk-s3' gem is available in your load path.
MSG

      private

      def upload_object(payload, key)
        raise S3_SDK_MESSAGE unless s3_sdk_loaded?
        super
      end

      def s3_sdk_loaded?
        require 'aws-sdk-s3' || true
      rescue LoadError
        false
      end
    end
  end
end
