require 'test_helper'

module Props
  class StringPropTest < Minitest::Test

    def test_valid?
      assert Humidifier::Props::StringProp.new.valid?('value')
      assert Humidifier::Props::StringProp.new.valid?(Humidifier.ref(Object.new))
      assert Humidifier::Props::StringProp.new.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute Humidifier::Props::StringProp.new.valid?(Object.new)
      refute Humidifier::Props::StringProp.new.valid?([])
      refute Humidifier::Props::StringProp.new.valid?({})
      refute Humidifier::Props::StringProp.new.valid?(1)
    end

    def test_convert_valid
      assert_equal 'test', Humidifier::Props::StringProp.new.convert('test')
    end

    def test_convert_invalid
      out, * = capture_io do
        assert_equal '5', Humidifier::Props::StringProp.new('Test').convert(5)
      end
      assert_match(/WARNING: Property test/, out)
    end
  end
end
