require 'test_helper'

class UtilsTest < Minitest::Test
  def test_underscore
    assert_nil Humidifier::Utils.underscore(nil)
    assert_equal 'foo', Humidifier::Utils.underscore('Foo')
    assert_equal 'foo_bar', Humidifier::Utils.underscore('FooBar')
    assert_equal 'foo_bar_baz', Humidifier::Utils.underscore('FooBarBaz')
    assert_equal 'foofoofoofoo_baar', Humidifier::Utils.underscore('FoofoofoofooBaar')
    assert_equal 'foo2_bar', Humidifier::Utils.underscore('FOO2Bar')
  end

  def test_underscored_empty
    assert_equal ({}), Humidifier::Utils.underscored({})
  end

  def test_underscored
    response = Humidifier::Utils.underscored(%w[TestA TestB])
    assert_equal ({ 'TestA' => :test_a, 'TestB' => :test_b }), response
    assert response.frozen?
  end
end
