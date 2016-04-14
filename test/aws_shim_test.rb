require 'test_helper'

class AWSShimTest < Minitest::Test

  def test_validate_stack
    stack = Object.new
    mock = Minitest::Mock.new
    mock.expect(:validate_stack, nil, [stack])

    proxy_shim(mock) do
      Humidifier::AWSShim.validate_stack(stack)
    end
    mock.verify
  end

  def test_noop
    noop = Humidifier::AWSShim::Noop.new
    out, * = capture_io do
      refute noop.validate_stack
    end
    assert_match(/WARNING/, out)
  end

  def test_noop_invalid
    noop = Humidifier::AWSShim::Noop.new
    assert_raises NoMethodError do
      noop.validate
    end
  end

  def test_sdk_v1
    sdk_v1 = Humidifier::AWSShim::SDKV1.new
    with_sdk_v1_loaded do
      assert sdk_v1.validate_stack(stack_double(true))
      refute sdk_v1.validate_stack(stack_double(false))
    end
  end

  def test_sdk_v2
    sdk_v2 = Humidifier::AWSShim::SDKV2.new
    with_sdk_v2_loaded do
      assert sdk_v2.validate_stack(stack_double(true))
      refute sdk_v2.validate_stack(stack_double(false))
    end
  end

  def test_initialize_noop
    assert_kind_of Humidifier::AWSShim::Noop, Humidifier::AWSShim.new.shim
  end

  def test_initialize_sdk_v1
    with_faked_sdk_require do
      with_sdk_v1_loaded do
        assert_kind_of Humidifier::AWSShim::SDKV1, Humidifier::AWSShim.new.shim
      end
    end
  end

  def test_initialize_sdk_v2
    with_faked_sdk_require do
      with_sdk_v2_loaded do
        assert_kind_of Humidifier::AWSShim::SDKV2, Humidifier::AWSShim.new.shim
      end
    end
  end

  private

  def proxy_shim(shim)
    old_shim = Humidifier::AWSShim.instance.shim
    Humidifier::AWSShim.instance.shim = shim
    yield
    Humidifier::AWSShim.instance.shim = old_shim
  end

  def stack_double(to_cf)
    stack = Object.new
    stack.singleton_class.send(:define_method, :to_cf) { to_cf }
    stack
  end

  # sorry
  def with_faked_sdk_require
    filepath = File.expand_path(File.join('..', 'aws-sdk.rb'), __FILE__)
    begin
      FileUtils.touch(filepath)
      yield
    ensure
      FileUtils.rm(filepath)
      $LOADED_FEATURES.reject! { |feature| feature.match(/aws-sdk/) }
    end
  end

  def with_sdk_v1_loaded
    load 'support/aws_sdk_v1.rb'
    yield
    Object.send(:remove_const, :AWS)
  end

  def with_sdk_v2_loaded
    load 'support/aws_sdk_v2.rb'
    yield
    Object.send(:remove_const, :Aws)
  end
end
