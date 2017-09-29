require 'test_helper'

class AwsShimTest < Minitest::Test
  class FakeShim
    attr_reader :stack

    def create(stack)
      @stack = stack
    end
  end

  def test_forwarding
    stack = Object.new
    shim = FakeShim.new

    Humidifier::AwsShim.stub(:shim, shim) do
      Humidifier::AwsShim.create(stack)
    end
    assert_equal stack, shim.stack
  end

  def test_initialize_sdk_version_1?
    with_config(sdk_version: 1) { assert_shim(:SDKV1) }
  end

  def test_initialize_sdk_version_2?
    with_config(sdk_version: 2) { assert_shim(:SDKV2) }
  end

  def test_initialize_sdk_version_3?
    with_config(sdk_version: 3) { assert_shim(:SDKV3) }
  end

  def test_guess_sdk_noop
    assert_shim(:Noop)
  end

  def test_guess_sdk_sdk_v1
    with_sdk_v1_loaded { assert_shim(:SDKV1) }
  end

  def test_guess_sdk_sdk_v2
    with_sdk_v2_loaded { assert_shim(:SDKV2) }
  end

  def test_guess_sdk_sdk_v3
    with_sdk_v3_loaded { assert_shim(:SDKV3) }
  end

  private

  def assert_shim(kind)
    expected = Humidifier::AwsAdapters.const_get(kind)
    assert_kind_of expected, Humidifier::AwsShim.new.shim
  end
end
