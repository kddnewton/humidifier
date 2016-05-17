require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_create
    with_sdk_v2_loaded do
      assert sdk.create(payload_double(to_cf: true))
      refute sdk.create(payload_double(to_cf: false))
    end
  end

  def test_delete
    with_sdk_v2_loaded do
      assert sdk.delete(payload_double)
    end
  end

  def test_exists?
    with_sdk_v2_loaded do
      assert sdk.exists?(payload_double)
      Aws::CloudFormation.stub(:exists?, false) do
        refute sdk.exists?(payload_double)
      end
    end
  end

  def test_update
    with_sdk_v2_loaded do
      assert sdk.update(payload_double(to_cf: true))
      refute sdk.update(payload_double(to_cf: false))
    end
  end

  def test_valid?
    with_sdk_v2_loaded do
      assert sdk.valid?(payload_double(to_cf: true))
      refute sdk.valid?(payload_double(to_cf: false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV2.new
  end
end
