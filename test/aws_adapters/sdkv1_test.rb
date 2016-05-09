require 'test_helper'

class SDKV1Test < Minitest::Test

  def test_create_stack
    with_sdk_v1_loaded do
      assert sdk.create_stack(stack_double(to_cf: true))
      refute sdk.create_stack(stack_double(to_cf: false))
    end
  end

  def test_validate_stack
    with_sdk_v1_loaded do
      assert sdk.validate_stack(stack_double(to_cf: true))
      refute sdk.validate_stack(stack_double(to_cf: false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV1.new
  end
end
