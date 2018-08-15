# frozen_string_literal: true

require 'test_helper'

module Props
  class DoublePropTest < Minitest::Test
    def test_valid?
      assert build.valid?(1.0)
      assert build.valid?(Humidifier.ref(Object.new))
      assert build.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?([])
      refute build.valid?({})
    end

    def test_convert_valid
      assert_equal 5.0, build.convert(5.0)
    end

    def test_convert_invalid
      out, * = capture_io { assert_equal 6.0, build.convert('6') }
      assert_match(/WARNING: Property test/, out)
    end

    private

    def build
      Humidifier::Props::DoubleProp.new('Test')
    end
  end
end
