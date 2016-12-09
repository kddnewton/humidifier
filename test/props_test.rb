require 'test_helper'

class PropsTest < Minitest::Test
  def test_list
    prop = Humidifier::Props.from('list', 'Type' => 'List', 'PrimitiveType' => 'Integer')
    assert_kind_of Humidifier::Props::ListProp, prop
    assert_equal 'list', prop.key
  end

  def test_map
    prop = Humidifier::Props.from('map', 'Type' => 'Map', 'PrimitiveType' => 'Integer')
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
    substructs = { 'Foobar' => { 'Properties' => { 'Alpha' => { 'PrimitiveType' => 'String' } } } }
    prop = Humidifier::Props.from('structure', { 'Type' => 'Foobar' }, substructs)
    assert_kind_of Humidifier::Props::StructureProp, prop
    assert_equal 'structure', prop.key
  end

  def test_api
    ObjectSpace.each_object(Humidifier::Props::Base.singleton_class) do |clazz|
      next if clazz == Humidifier::Props::Base
      assert_respond_to clazz.new, :convert
      assert_respond_to clazz.new, :valid?
    end
  end
end
