require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_create_stack
    with_sdk_v2_loaded do
      assert sdk.create_stack(stack_double(true))
      refute sdk.create_stack(stack_double(false))
    end
  end

  def test_validate_stack
    with_sdk_v2_loaded do
      assert sdk.validate_stack(stack_double(true))
      refute sdk.validate_stack(stack_double(false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV2.new
  end
end
