# frozen_string_literal: true

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
      assert build.valid?([1, 2])
      refute build.valid?([1, 'foo'])
    end

    def test_to_cf
      assert_equal ['Test', [1, 2]], build.to_cf([1, 2])
      assert_equal ['Test', [1, 2]], build.to_cf([1, 2])
    end

    def test_to_cf_ref
      actual = build.to_cf(Humidifier.ref('Foo'))
      assert_equal ['Test', { 'Ref' => 'Foo' }], actual
    end

    private

    def build
      Humidifier::Props::ListProp.new('Test', 'PrimitiveType' => 'Integer')
    end
  end
end
