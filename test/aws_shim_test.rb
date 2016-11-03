require 'test_helper'

class AwsShimTest < Minitest::Test

  def test_forwarding
    stack = Object.new
    mock = Minitest::Mock.new
    mock.expect(:valid?, nil, [stack])

    Humidifier::AwsShim.stub(:shim, mock) do
      Humidifier::AwsShim.valid?(stack)
    end
    mock.verify
  end

  def test_initialize_sdk_version_1?
    with_config(sdk_version: 1) { assert_shim(:SDKV1) }
  end

  def test_initialize_sdk_version_2?
    with_config(sdk_version: 2) { assert_shim(:SDKV2) }
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

  private

  def assert_shim(kind)
    expected = Humidifier::AwsAdapters.const_get(kind)
    assert_kind_of expected, Humidifier::AwsShim.new.shim
  end
end
