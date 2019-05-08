# frozen_string_literal: true

require 'test_helper'

module Humidifier
  module Props
    class BooleanPropTest < Minitest::Test
      def test_takes_true
        assert build.valid?(true)
      end

      def test_takes_false
        assert build.valid?(false)
      end

      def test_rejects_other_values
        refute build.valid?(Object.new)
        refute build.valid?([])
        refute build.valid?({})
        refute build.valid?(1)
      end

      private

      def build
        BooleanProp.new('Test')
      end
    end
  end
end
