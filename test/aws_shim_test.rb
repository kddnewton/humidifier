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
end
