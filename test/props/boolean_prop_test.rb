require 'test_helper'

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

    def test_convert_valid
      assert build.convert(true)
    end

    def test_convert_invalid
      out, * = capture_io { assert build.convert('true') }
      assert_match(/WARNING: Property test/, out)
    end

    private

    def build
      Humidifier::Props::BooleanProp.new('Test')
    end
  end
end
