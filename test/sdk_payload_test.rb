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

  private

  def build
    Humidifier::SdkPayload.new(StackDouble.new('identifier', 'name', 'to_cf'), foo: 'bar')
  end
end
