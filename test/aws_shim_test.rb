require 'test_helper'

class AwsShimTest < Minitest::Test

  def test_forwarding
    stack = Object.new
    mock = Minitest::Mock.new
    mock.expect(:valid?, nil, [stack])

    Humidifier::Core::AwsShim.stub(:shim, mock) do
      Humidifier::Core::AwsShim.valid?(stack)
    end
    mock.verify
  end

  def test_initialize_noop
    assert_kind_of Humidifier::Core::AwsAdapters::Noop, Humidifier::Core::AwsShim.new.shim
  end

  def test_initialize_sdk_v1
    with_sdk_v1_loaded do
      assert_kind_of Humidifier::Core::AwsAdapters::SDKV1, Humidifier::Core::AwsShim.new.shim
    end
  end

  def test_initialize_sdk_v2
    with_sdk_v2_loaded do
      assert_kind_of Humidifier::Core::AwsAdapters::SDKV2, Humidifier::Core::AwsShim.new.shim
    end
  end
end
