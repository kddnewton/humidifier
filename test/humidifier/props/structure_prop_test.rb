# frozen_string_literal: true

require "test_helper"

module Humidifier
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
        assert build.valid?(beta: "gamma")
        refute build.valid?(beta: 1)
      end

      def test_to_cf
        actual = build.to_cf(beta: "gamma")
        assert_equal ["Alpha", { "Beta" => "gamma" }], actual
      end

      def test_to_cf_ref
        actual = build.to_cf(Humidifier.ref("Foo"))
        assert_equal ["Alpha", { "Ref" => "Foo" }], actual
      end

      private

      def build
        StructureProp.new("Alpha", {}, { "beta" => StringProp.new("Beta") })
      end
    end
  end
end
