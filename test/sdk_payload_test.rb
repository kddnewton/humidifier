require 'test_helper'

class SdkPayloadTest < Minitest::Test
  StackDouble = Struct.new(:identifier, :name, :to_cf)

  def test_forwarding
    assert_equal 'identifier', build.identifier
    assert_equal 'name', build.name
    assert_equal 'to_cf', build.to_cf
  end

  def test_options
    assert_equal ({ foo: 'bar' }), build.options
  end

  def test_merge
    payload = build
    payload.merge(bar: 'foo')

    assert_equal 'foo', payload.options[:bar]
  end

  def test_merge_no_overwrite
    payload = build
    payload.merge(foo: 'foo')

    assert_equal 'bar', payload.options[:foo]
  end

  private

  def build
    Humidifier::Core::SdkPayload.new(StackDouble.new('identifier', 'name', 'to_cf'), foo: 'bar')
  end
end
