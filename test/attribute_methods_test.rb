require 'test_helper'

class AttributeMethodsTest < Minitest::Test
  class Slate
    include Humidifier::AttributeMethods
  end

  def test_attr_accessor
    slate = Slate.new
    Humidifier::AttributeMethods.const_get(:ATTRIBUTES).each do |att|
      assert_respond_to slate, att
      assert_respond_to slate, :"#{att}="
    end
  end

  def test_common_attributes
    slate = Slate.new
    slate.depends_on = 'foo'
    slate.metadata = 'bar'
    assert_equal ({ 'DependsOn' => 'foo', 'Metadata' => 'bar' }), slate.common_attributes
  end
end
