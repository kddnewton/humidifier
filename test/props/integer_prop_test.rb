require 'test_helper'

module Props
  class IntegerPropTest < Minitest::Test

    def test_valid?
      assert valid?(1)
      assert valid?(Humidifier.ref(Object.new))
      assert valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute valid?(Object.new)
      refute valid?([])
      refute valid?({})
      refute valid?(1.0)
    end

    def test_convert_valid
      assert_equal 5, Humidifier::Core::Props::IntegerProp.new.convert(5)
    end

    def test_convert_invalid
      out, * = capture_io do
        assert_equal 6, Humidifier::Core::Props::IntegerProp.new('Test').convert('6')
      end
      assert_match(/WARNING: Property test/, out)
    end

    private

    def valid?(object)
      Humidifier::Core::Props::IntegerProp.new.valid?(object)
    end
  end
end
