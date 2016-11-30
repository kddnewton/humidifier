require 'test_helper'

module Props
  class MapPropTest < Minitest::Test
    def test_valid?
      assert build.valid?({})
      assert build.valid?(Humidifier.ref(Object.new))
      assert build.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?([])
      refute build.valid?(false)
      refute build.valid?(1.0)
    end

    def test_with_subprop
      prop = build('Test', 'PrimitiveType' => 'Integer')
      assert prop.valid?('foo' => 1, 'bar' => 2)
      refute prop.valid?('foo' => 1, 'bar' => '2')
    end

    private

    def build(key = 'Test', spec = {})
      Humidifier::Props::MapProp.new(key, spec)
    end
  end
end
