# frozen_string_literal: true

require 'test_helper'

class PropTest < Minitest::Test
  def test_name_conversion
    assert_equal 'my_test_key', Humidifier::Props::Prop.new('MyTestKey').name
  end

  def test_to_cf
    base = Humidifier::Props::Prop.new('MyTestKey')
    value = Object.new

    assert_equal ['MyTestKey', value], base.to_cf(value)
  end

  def test_documentation
    prop = Humidifier::Props::Prop.new('Test', 'Documentation' => 'docu')
    assert_equal 'docu', prop.documentation
  end

  def test_required?
    assert Humidifier::Props::Prop.new('Test', 'Required' => true).required?
  end

  def test_update_type
    prop = Humidifier::Props::Prop.new('Test', 'UpdateType' => 'update_type')
    assert_equal 'update_type', prop.update_type
  end
end
