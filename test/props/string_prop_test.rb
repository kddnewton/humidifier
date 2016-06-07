require 'test_helper'

module Props
  class StringPropTest < Minitest::Test

    def test_valid?
      assert valid?('value')
      assert valid?(Humidifier.ref(Object.new))
      assert valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute valid?(Object.new)
      refute valid?([])
      refute valid?({})
      refute valid?(1)
    end

    def test_convert_valid
      assert_equal 'test', Humidifier::Core::Props::StringProp.new.convert('test')
    end

    def test_convert_invalid
      out, * = capture_io do
        assert_equal '5', Humidifier::Core::Props::StringProp.new('Test').convert(5)
      end
      assert_match(/WARNING: Property test/, out)
    end

    private

    def valid?(object)
      Humidifier::Core::Props::StringProp.new.valid?(object)
    end
  end
end
