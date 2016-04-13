require 'test_helper'

class PropsTest < Minitest::Test

  def test_boolean
    prop = Humidifier::Props.from('"BooleanKey" : Boolean')
    assert_kind_of Humidifier::Props::BooleanProp, prop
    assert_equal 'BooleanKey', prop.key
  end

  def test_integer
    prop = Humidifier::Props.from('"IntegerKey" : Integer')
    assert_kind_of Humidifier::Props::IntegerProp, prop
    assert_equal 'IntegerKey', prop.key
  end

  def test_string
    prop = Humidifier::Props.from('"StringKey" : String')
    assert_kind_of Humidifier::Props::StringProp, prop
    assert_equal 'StringKey', prop.key
  end

  def test_array
    prop = Humidifier::Props.from('"ArrayKey" : [ String ]')
    assert_kind_of Humidifier::Props::ArrayProp, prop
    assert_equal 'ArrayKey', prop.key
  end

  def test_json
    prop = Humidifier::Props.from('"JSONKey" : { JSON }')
    assert_kind_of Humidifier::Props::JSONProp, prop
    assert_equal 'JSONKey', prop.key
  end
end
