require 'test_helper'

class SerializerTest < Minitest::Test

  def test_hash
    value = Object.new
    assert_equal ({ foo: value }), Humidifier::Serializer.dump(foo: value)
  end

  def test_array
    value = Object.new
    assert_equal [value], Humidifier::Serializer.dump([value])
  end

  def test_ref
    value = Object.new
    ref = Humidifier.ref(value)
    assert_equal ({ 'Ref' => value }), Humidifier::Serializer.dump(ref)
  end

  def test_fn
    value = Object.new
    fn = Humidifier.fn.base64(value)
    assert_equal ({ 'Fn::Base64' => value }), Humidifier::Serializer.dump(fn)
  end

  def test_others
    value = Object.new
    assert_equal value, Humidifier::Serializer.dump(value)
  end

  def test_integration
    reference1 = Object.new
    reference2 = Object.new
    value = [{ 'Container' => Humidifier.ref(reference1) }, Humidifier.fn.base64(Humidifier.ref(reference2))]

    expected = [
      { 'Container' => { 'Ref' => reference1 } },
      { 'Fn::Base64' => { 'Ref' => reference2 } }
    ]
    assert_equal expected, Humidifier::Serializer.dump(value)
  end
end
