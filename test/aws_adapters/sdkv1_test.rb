require 'test_helper'

class SDKV1Test < Minitest::Test

  def setup
    load_sdk_v1
  end

  def teardown
    unload_sdk_v1
  end

  def test_exists?
    assert sdk.exists?(payload_double)
    AWS::CloudFormation.stub(:exists?, false) do
      refute sdk.exists?(payload_double)
    end
  end

  def test_create_and_wait
    assert sdk.create_and_wait(payload_double)
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV1.new
  end
end
