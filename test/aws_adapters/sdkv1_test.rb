require 'test_helper'

class SDKV1Test < Minitest::Test

  def test_sdk_v1
    sdk_v1 = Humidifier::AwsAdapters::SDKV1.new
    with_sdk_v1_loaded do
      assert sdk_v1.validate_stack(stack_double(true))
      refute sdk_v1.validate_stack(stack_double(false))
    end
  end
end
