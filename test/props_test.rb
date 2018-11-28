# frozen_string_literal: true

require 'test_helper'

class PropsTest < Minitest::Test
  def test_list
    config = { 'Type' => 'List', 'PrimitiveType' => 'Integer' }
    prop = Humidifier::Props.from('list', config)
    assert_kind_of Humidifier::Props::ListProp, prop
    assert_equal 'list', prop.key
  end

  def test_map
    config = { 'Type' => 'Map', 'PrimitiveType' => 'Integer' }
    prop = Humidifier::Props.from('map', config)
    assert_kind_of Humidifier::Props::MapProp, prop
    assert_equal 'map', prop.key
  end

  def test_boolean
    prop = Humidifier::Props.from('boolean', 'PrimitiveType' => 'Boolean')
    assert_kind_of Humidifier::Props::BooleanProp, prop
    assert_equal 'boolean', prop.key
  end

  def test_double
    prop = Humidifier::Props.from('double', 'PrimitiveType' => 'Double')
    assert_kind_of Humidifier::Props::DoubleProp, prop
    assert_equal 'double', prop.key
  end

  def test_integer
    prop = Humidifier::Props.from('integer', 'PrimitiveType' => 'Integer')
    assert_kind_of Humidifier::Props::IntegerProp, prop
    assert_equal 'integer', prop.key
  end

  def test_json
    prop = Humidifier::Props.from('json', 'PrimitiveType' => 'Json')
    assert_kind_of Humidifier::Props::JsonProp, prop
    assert_equal 'json', prop.key
  end

  def test_string
    prop = Humidifier::Props.from('string', 'PrimitiveType' => 'String')
    assert_kind_of Humidifier::Props::StringProp, prop
    assert_equal 'string', prop.key
  end

  def test_structure
    substructs = { 'Foobar' => {
      'Properties' => { 'Alpha' => { 'PrimitiveType' => 'String' } }
    } }

    config = { 'Type' => 'Foobar' }
    prop = Humidifier::Props.from('structure', config, substructs)
    assert_kind_of Humidifier::Props::StructureProp, prop
    assert_equal 'structure', prop.key
  end

  def test_api
    ObjectSpace.each_object(Humidifier::Props::Base.singleton_class) do |clazz|
      next if %w[Base TestProp].include?(clazz.name.split('::').last)

      assert_respond_to clazz.new('Foo'), :convert
      assert_respond_to clazz.new('Bar'), :valid?
    end
  end
end
