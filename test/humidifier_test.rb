# frozen_string_literal: true

require "test_helper"

class HumidifierTest < Minitest::Test
  def test_config
    assert_kind_of Humidifier::Config, Humidifier.config
  end

  def test_configure
    Humidifier.configure do |config|
      assert_kind_of Humidifier::Config, config
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
    Humidifier.stub(:registry, { foo: "bar" }) do
      assert_equal "bar", Humidifier[:foo]
    end
  end

  def test_underscore_empty
    assert_equal ({}), Humidifier.underscore({})
  end

  def test_underscore
    response = Humidifier.underscore(%w[TestA TestB])
    assert_equal ({ "TestA" => :test_a, "TestB" => :test_b }), response
    assert response.frozen?
  end
end
