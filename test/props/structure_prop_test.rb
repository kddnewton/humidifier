require 'test_helper'

module Props
  class StructurePropTest < Minitest::Test
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

    def test_subprop
      assert build.valid?(alpha: { beta: 'gamma' })
      refute build.valid?(alpha: { beta: 1 })
    end

    private

    def build
      substructs = { 'Sub' => { 'Properties' => { 'Beta' => { 'PrimitiveType' => 'String' } } } }
      Humidifier::Props::MapProp.new('Alpha', { 'Type' => 'Sub' }, substructs)
    end
  end
end
