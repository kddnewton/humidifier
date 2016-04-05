require 'test_helper'

class PropsTest < Minitest::Test

  def test_boolean
    prop = AwsCF::Props.from('"BooleanKey" : Boolean')
    assert_kind_of AwsCF::Props::BooleanProp, prop
    assert_equal 'BooleanKey', prop.key
  end

  def test_integer
    prop = AwsCF::Props.from('"IntegerKey" : Integer')
    assert_kind_of AwsCF::Props::IntegerProp, prop
    assert_equal 'IntegerKey', prop.key
  end

  def test_string
    prop = AwsCF::Props.from('"StringKey" : String')
    assert_kind_of AwsCF::Props::StringProp, prop
    assert_equal 'StringKey', prop.key
  end

  def test_array
    prop = AwsCF::Props.from('"ArrayKey" : [ String ]')
    assert_kind_of AwsCF::Props::ArrayProp, prop
    assert_kind_of AwsCF::Props::StringProp, prop.sub_prop
    assert_equal 'ArrayKey', prop.key
  end

  def test_json
    prop = AwsCF::Props.from('"JSONKey" : { JSON }')
    assert_kind_of AwsCF::Props::JSONProp, prop
    assert_equal 'JSONKey', prop.key
  end
end
