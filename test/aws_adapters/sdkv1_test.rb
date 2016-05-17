require 'test_helper'

class SDKV1Test < Minitest::Test

  def test_create
    with_sdk_v1_loaded do
      assert sdk.create(payload_double)
      refute sdk.create(payload_double(to_cf: false))
    end
  end

  def test_delete
    with_sdk_v1_loaded do
      assert sdk.delete(payload_double)
    end
  end

  def test_exists?
    with_sdk_v1_loaded do
      assert sdk.exists?(payload_double)
      AWS::CloudFormation.stub(:exists?, false) do
        refute sdk.exists?(payload_double)
      end
    end
  end

  def test_update
    with_sdk_v1_loaded do
      assert sdk.update(payload_double)
      refute sdk.update(payload_double(to_cf: false))
    end
  end

  def test_valid?
    with_sdk_v1_loaded do
      assert sdk.valid?(payload_double)
      refute sdk.valid?(payload_double(to_cf: false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV1.new
  end
end
