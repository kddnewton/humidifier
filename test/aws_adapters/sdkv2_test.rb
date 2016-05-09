require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_create_stack
    with_sdk_v2_loaded do
      assert sdk.create_stack(stack_double(to_cf: true))
      refute sdk.create_stack(stack_double(to_cf: false))
    end
  end

  def test_delete_stack
    with_sdk_v2_loaded do
      assert sdk.delete_stack(stack_double)
    end
  end

  def test_validate_stack
    with_sdk_v2_loaded do
      assert sdk.validate_stack(stack_double(to_cf: true))
      refute sdk.validate_stack(stack_double(to_cf: false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV2.new
  end
end
