require 'test_helper'

class SDKV2Test < Minitest::Test

  def setup
    load_sdk_v2
  end

  def teardown
    unload_sdk_v2
  end

  def test_create
    assert sdk.create(payload_double)
    refute sdk.create(payload_double(to_cf: false))
  end

  def test_delete
    assert sdk.delete(payload_double)
  end

  def test_exists?
    assert sdk.exists?(payload_double)
    Aws::CloudFormation.stub(:exists?, false) do
      refute sdk.exists?(payload_double)
    end
  end

  def test_update
    assert sdk.update(payload_double)
    refute sdk.update(payload_double(to_cf: false))
  end

  def test_valid?
    assert sdk.valid?(payload_double)
    refute sdk.valid?(payload_double(to_cf: false))
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV2.new
  end
end
