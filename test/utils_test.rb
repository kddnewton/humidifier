require 'test_helper'

class UtilsTest < Minitest::Test
  def test_camelize
    assert_equal 'Foo',       Humidifier::Utils.camelize('foo')
    assert_equal 'FooBar',    Humidifier::Utils.camelize('foo_bar')
    assert_equal 'FooBarBaz', Humidifier::Utils.camelize('foo_bar_baz')
  end

  def test_underscore
    assert_equal 'foo',         Humidifier::Utils.underscore('Foo')
    assert_equal 'foo_bar',     Humidifier::Utils.underscore('FooBar')
    assert_equal 'foo_bar_baz', Humidifier::Utils.underscore('FooBarBaz')
  end
end
