require 'test_helper'

class HumidifierTest < Minitest::Test

  def test_config
    assert_kind_of Humidifier::Configuration, Humidifier.config
  end

  def test_configure
    Humidifier.configure do |config|
      assert_kind_of Humidifier::Configuration, config
    end
  end

  def test_fn
    assert_equal Humidifier::Fn, Humidifier.fn
  end

  def test_ref
    reference = Object.new
    assert_kind_of Humidifier::Ref, Humidifier.ref(reference)
    assert_equal reference, Humidifier.ref(reference).reference
  end

  def test_brackets
    Humidifier.stub(:registry, foo: 'bar') do
      assert_equal 'bar', Humidifier[:foo]
    end
  end
end
