require 'test_helper'

class PropsTest < Minitest::Test
  def test_list
    prop = Humidifier::Props.from('list', 'Type' => 'List')
    assert_kind_of Humidifier::Props::ListProp, prop
    assert_equal 'list', prop.key
  end

  def test_map
    prop = Humidifier::Props.from('map', 'Type' => 'Map')
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

  # TODO: update this when we integrate structures
  def test_structure
    prop = Humidifier::Props.from('structure', {})
    assert_kind_of Humidifier::Props::JsonProp, prop
    assert_equal 'structure', prop.key
  end
end
