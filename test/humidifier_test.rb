require 'test_helper'

class HumidifierTest < Minitest::Test

  def test_fn
    assert_equal Humidifier::Fn, Humidifier.fn
  end

  def test_ref
    reference = Object.new
    assert_kind_of Humidifier::Ref, Humidifier.ref(reference)
    assert_equal reference, Humidifier.ref(reference).reference
  end

  def test_brackets
    with_fake_registry do
      assert_equal 'bar', Humidifier[:foo]
    end
  end

  private

  def with_fake_registry
    old_registry = Humidifier::Resource.registry
    Humidifier::Resource.registry = { foo: 'bar' }
    yield
    Humidifier::Resource.registry = old_registry
  end
end
