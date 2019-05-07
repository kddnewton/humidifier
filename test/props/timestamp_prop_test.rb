# frozen_string_literal: true

require 'test_helper'

module Props
  class TimestampPropTest < Minitest::Test
    def test_valid?
      assert build.valid?(Time.now.to_datetime)
    end

    def test_valid_humidifier_structures
      assert build.valid?(Humidifier.ref(Object.new))
      assert build.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?([])
      refute build.valid?({})
      refute build.valid?(1.0)
    end

    private

    def build
      Humidifier::Props::TimestampProp.new('Test')
    end
  end
end
