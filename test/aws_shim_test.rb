require 'test_helper'

class AwsShimTest < Minitest::Test

  def test_validate_stack
    stack = Object.new
    mock = Minitest::Mock.new
    mock.expect(:validate_stack, nil, [stack])

    proxy_shim(mock) do
      Humidifier::AwsShim.validate_stack(stack)
    end
    mock.verify
  end

  def test_initialize_noop
    assert_kind_of Humidifier::AwsAdapters::Noop, Humidifier::AwsShim.new.shim
  end

  def test_initialize_sdk_v1
    with_sdk_v1_loaded do
      assert_kind_of Humidifier::AwsAdapters::SDKV1, Humidifier::AwsShim.new.shim
    end
  end

  def test_initialize_sdk_v2
    with_sdk_v2_loaded do
      assert_kind_of Humidifier::AwsAdapters::SDKV2, Humidifier::AwsShim.new.shim
    end
  end

  private

  def proxy_shim(shim)
    old_shim = Humidifier::AwsShim.instance.shim
    Humidifier::AwsShim.instance.shim = shim
    yield
    Humidifier::AwsShim.instance.shim = old_shim
  end
end
