require 'test_helper'

module Props
  class BooleanPropTest < Minitest::Test

    def test_takes_true
      assert valid?(true)
    end

    def test_takes_false
      assert valid?(false)
    end

    def test_rejects_other_values
      refute valid?(Object.new)
      refute valid?([])
      refute valid?({})
      refute valid?(1)
    end

    def test_convert_valid
      assert Humidifier::Core::Props::BooleanProp.new.convert(true)
    end

    def test_convert_invalid
      out, * = capture_io do
        assert Humidifier::Core::Props::BooleanProp.new('Test').convert('true')
      end
      assert_match(/WARNING: Property test/, out)
    end

    private

    def valid?(object)
      Humidifier::Core::Props::BooleanProp.new.valid?(object)
    end
  end
end
