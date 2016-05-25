require 'test_helper'

class ExtensionTest < Minitest::Test

  def test_basic
    assert_equal 'foo',               Humidifier::Utils.underscore('Foo')
    assert_equal 'foo_bar',           Humidifier::Utils.underscore('FooBar')
    assert_equal 'foo_bar_baz',       Humidifier::Utils.underscore('FooBarBaz')
    assert_equal 'foofoofoofoo_baar', Humidifier::Utils.underscore('FoofoofoofooBaar')
  end

  Humidifier.registry.each do |name, clazz|
    clazz.props.each do |name, prop|
      define_method(:"test_#{name}") do
        assert_equal expected_for(prop.key), name
      end
    end
  end

  private

  def expected_for(str)
    response = str.delete(':').gsub(/([A-Z]+)([0-9]|[A-Z]|\z)/) { "#{$1.capitalize}#{$2}" }
    response[0] = response[0].downcase
    response = response.sub(/(.)([A-Z])/) { |match| "#{$1}_#{$2.downcase}" } while /[A-Z]/ === response
    response.downcase
  end
end
