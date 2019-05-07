# frozen_string_literal: true

require 'test_helper'

class ResourceTest < Minitest::Test
  Humidifier::Resource.props = {
    'one' => Humidifier::Props::StringProp.new('One'),
    'two' => Humidifier::Props::IntegerProp.new('Two')
  }
  Humidifier::Resource.aws_name = 'AWS::Resource'

  def test_method_missing_reader
    resource = build
    assert_equal 'one', resource.one
  end

  def test_method_missing_writer
    resource = build
    resource.one = 'three'
    assert_equal 'three', resource.one
  end

  def test_respond_to_missing?
    resource = build
    Humidifier::Resource.props.each_key do |key|
      assert resource.respond_to?(key)
      assert resource.respond_to?("#{key}=")
    end
  end

  def test_respond_to_missing_invalid
    resource = build
    assert_raises NoMethodError do
      resource.foo
    end
  end

  def test_to_cf
    resource = build
    expected = {
      'Type' => 'AWS::Resource',
      'Properties' => { 'One' => 'one', 'Two' => 2 }
    }

    assert_equal expected, resource.to_cf
  end

  def test_update
    assert_equal ({ 'one' => 'one', 'two' => 2 }), build.properties
  end

  def test_update_attributes
    resource = build
    resource.update_attributes(condition: 'foo', creation_policy: 'bar')

    assert_equal 'foo', resource.condition
    assert_equal 'bar', resource.creation_policy
  end

  def test_update_attributes_invalid
    resource = build

    assert_raises ArgumentError do
      resource.update_attributes(foo: 'bar')
    end
  end

  def test_update_property
    resource = build
    resource.update_property('one', 'three')
    assert_equal ({ 'one' => 'three', 'two' => 2 }), resource.properties
  end

  def test_update_property_invalid_property
    assert_raises ArgumentError do
      build.update_property('three', 3)
    end
  end

  def test_update_property_invalid_value
    assert_raises ArgumentError do
      build.update_property('one', 1)
    end
  end

  def test_prop?
    assert Humidifier::Resource.prop?('one')
    refute Humidifier::Resource.prop?('three')
  end

  def test_condition
    resource = build
    resource.condition = 'Bar'
    assert resource.to_cf['Condition'] = 'Bar'
  end

  def test_common_attributes
    resource = build
    resource.depends_on = 'foo'
    resource.metadata = 'bar'

    expected = { 'DependsOn' => 'foo', 'Metadata' => 'bar' }
    actual = resource.to_cf.reject { |key| %w[Type Properties].include?(key) }

    assert_equal expected, actual
  end

  private

  def build
    Humidifier::Resource.new(one: 'one', two: 2)
  end
end
