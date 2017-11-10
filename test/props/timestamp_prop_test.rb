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

    def test_convert_valid
      value = Time.now.to_datetime
      assert_equal value, build.convert(value)
    end

    def test_convert_invalid
      value = Time.at(0).utc.to_datetime
      out, * =
        capture_io { assert_equal value, build.convert(value.iso8601.to_s) }
      assert_match(/WARNING: Property test/, out)
    end

    private

    def build
      Humidifier::Props::TimestampProp.new('Test')
    end
  end
end
