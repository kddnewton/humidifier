require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_sdk_v2
    sdk_v2 = Humidifier::AwsAdapters::SDKV2.new
    with_sdk_v2_loaded do
      assert sdk_v2.validate_stack(stack_double(true))
      refute sdk_v2.validate_stack(stack_double(false))
    end
  end
end
