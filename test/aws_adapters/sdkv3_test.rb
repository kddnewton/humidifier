require 'test_helper'

class SDKV3Test < Minitest::Test
  def test_upload_raises_no_s3
    with_config(s3_bucket: 'test.s3.bucket') do
      with_sdk_v3_loaded do |sdk|
        sdk.stub(:require, -> (name) { raise LoadError }) do
          assert_raises do
            sdk.upload(payload(identifier: 'identifier', to_cf: 'body'))
          end
        end
      end
    end
  end

  def test_upload_with_s3
    with_config(s3_bucket: 'test.s3.bucket') do
      with_sdk_v3_loaded do |sdk|
        sdk.stub(:require, true) do
          SdkSupport.expect(:config, [], SdkSupport.double)
          SdkSupport.expect(:update, [region: Humidifier::AwsShim::REGION])
          SdkSupport.expect(:put_object, [body: 'body', bucket: 'test.s3.bucket', key: 'identifier.json'])
          SdkSupport.expect(:presigned_url, [:get])
          sdk.upload(payload(identifier: 'identifier', to_cf: 'body'))
          SdkSupport.verify
        end
      end
    end
  end
end
