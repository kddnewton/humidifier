# frozen_string_literal: true

require 'test_helper'

class PropertyMethodsTest < Minitest::Test
  def test_build_property_reader
    slate = build_slate
    slate.build_property_reader(:foo)
    resource = slate.new('foo' => 'bar')

    assert resource.respond_to?(:foo)
    assert_equal 'bar', resource.foo
  end

  def test_build_property_writer
    slate = build_slate
    slate.build_property_writer(:foo=)
    resource = slate.new

    assert resource.respond_to?(:foo=)
    resource.foo = 'bar'
    assert_equal 'bar', resource.properties['foo']
  end

  private

  def build_slate
    Class.new(Humidifier::Resource) do
      self.props = { 'foo' => Humidifier::Props::StringProp.new('Foo') }
    end
  end
end
