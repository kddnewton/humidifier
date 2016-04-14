require 'test_helper'

class PropertyMethodsTest < Minitest::Test
  class Slate
    extend Humidifier::PropertyMethods
    attr_accessor :properties

    def initialize(properties = {})
      self.properties = properties
    end

    def update_property(key, value)
      properties[key] = value
    end
  end

  def test_build_property_reader
    Slate.build_property_reader(:foo)
    slate = Slate.new('foo' => 'bar')

    assert slate.respond_to?(:foo)
    assert_equal 'bar', slate.foo
  end

  def test_build_property_writer
    Slate.build_property_writer(:foo=)
    slate = Slate.new

    assert slate.respond_to?(:foo=)
    slate.foo = 'bar'
    assert_equal 'bar', slate.properties['foo']
  end
end
