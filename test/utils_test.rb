require 'test_helper'

class UtilsTest < Minitest::Test

  def test_dump_hash
    value = Object.new
    assert_equal ({ foo: value }), Humidifier::Utils.dump(foo: value)
  end

  def test_dump_array
    value = Object.new
    assert_equal [value], Humidifier::Utils.dump([value])
  end

  def test_dump_ref
    value = Object.new
    ref = Humidifier.ref(value)
    assert_equal ({ 'Ref' => value }), Humidifier::Utils.dump(ref)
  end

  def test_dump_fn
    value = Object.new
    fn = Humidifier.fn.base64(value)
    assert_equal ({ 'Fn::Base64' => value }), Humidifier::Utils.dump(fn)
  end

  def test_dump_others
    value = Object.new
    assert_equal value, Humidifier::Utils.dump(value)
  end

  def test_dump_integration
    reference1 = Object.new
    reference2 = Object.new
    value = [{ 'Container' => Humidifier.ref(reference1) }, Humidifier.fn.base64(Humidifier.ref(reference2))]

    expected = [
      { 'Container' => { 'Ref' => reference1 } },
      { 'Fn::Base64' => { 'Ref' => reference2 } }
    ]
    assert_equal expected, Humidifier::Utils.dump(value)
  end

  def test_enumerable_to_h
    actual = Humidifier::Utils.enumerable_to_h(%w[a b c d]) { |item| [item.to_sym, item.ord] }
    assert_equal ({ a: 97, b: 98, c: 99, d: 100 }), actual
  end

  def test_underscore
    assert_equal 'foo',               Humidifier::Utils.underscore('Foo')
    assert_equal 'foo_bar',           Humidifier::Utils.underscore('FooBar')
    assert_equal 'foo_bar_baz',       Humidifier::Utils.underscore('FooBarBaz')
    assert_equal 'foofoofoofoo_baar', Humidifier::Utils.underscore('FoofoofoofooBaar')
  end
end
