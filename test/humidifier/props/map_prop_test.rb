# frozen_string_literal: true

require 'test_helper'

module Humidifier
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

      def test_subprop
        assert build.valid?('foo' => 1, 'bar' => 2)
        refute build.valid?('foo' => 1, 'bar' => '2')
      end

      def test_to_cf
        value = { 'Foo' => 1, 'Bar' => 2 }
        assert_equal ['Test', value], build.to_cf(value)
      end

      def test_to_cf_ref
        actual = build.to_cf(Humidifier.ref('Foo'))
        assert_equal ['Test', { 'Ref' => 'Foo' }], actual
      end

      private

      def build
        MapProp.new('Test', {}, IntegerProp.new('Test'))
      end
    end
  end
end
