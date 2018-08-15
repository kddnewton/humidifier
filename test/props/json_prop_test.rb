# frozen_string_literal: true

require 'test_helper'

module Props
  class JsonPropTest < Minitest::Test
    def test_valid?
      assert build.valid?({})
      assert build.valid?(Humidifier.ref(Object.new))
      assert build.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?('{}')
      refute build.valid?(1)
    end

    def test_convert_valid
      value = { 'alpha' => 'beta' }
      assert_equal value, build.convert(value)
    end

    def test_convert_invalid_bad_value
      value = Object.new
      assert_equal value, build.convert(value)
    end

    def test_convert_invalid
      out, * =
        capture_io do
          assert_equal ({ 'foo' => 'bar' }), build.convert([%w[foo bar]])
        end
      assert_match(/WARNING: Property test/, out)
    end

    private

    def build
      Humidifier::Props::JsonProp.new('Test')
    end
  end
end
