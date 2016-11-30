require 'test_helper'

module Props
  class ListPropTest < Minitest::Test
    def test_valid?
      assert build.valid?([])
      assert build.valid?(Humidifier.ref(Object.new))
      assert build.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?(false)
      refute build.valid?(1.0)
    end

    def test_with_subprop
      prop = build('Test', 'PrimitiveType' => 'Integer')
      assert prop.valid?([1, 2])
      refute prop.valid?([1, 'foo'])
    end

    private

    def build(key = 'Test', spec = {})
      Humidifier::Props::ListProp.new(key, spec)
    end
  end
end
