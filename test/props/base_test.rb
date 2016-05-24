require 'test_helper'

module Props
  class BaseTest < Minitest::Test
    class TestProp < Humidifier::Props::Base
      def convert; end
    end

    def test_name_conversion
      base = Humidifier::Props::Base.new('MyTestKey')
      assert_equal 'my_test_key', base.name
    end

    def test_to_cf
      base = Humidifier::Props::Base.new('MyTestKey')
      value = Object.new

      mock = Minitest::Mock.new
      mock.expect(:call, value, [value])

      Humidifier::Utils.stub(:dump, mock) do
        assert_equal ['MyTestKey', value], base.to_cf(value)
      end
      mock.verify
    end

    def test_convertable?
      refute Humidifier::Props::Base.new.convertable?
      assert TestProp.new.convertable?
    end

    def test_whitelisted_value?
      base = Humidifier::Props::Base.new
      original_whitelist = Humidifier::Props::Base::WHITELIST

      suppress_warnings do
        Humidifier::Props::Base.const_set(:WHITELIST, [])
        refute base.whitelisted_value?('test')

        Humidifier::Props::Base::WHITELIST << String
        assert base.whitelisted_value?('test')

        Humidifier::Props::Base.const_set(:WHITELIST, original_whitelist)
      end
    end

    private

    def suppress_warnings
      warn_level = $VERBOSE
      $VERBOSE = nil
      yield
      $VERBOSE = warn_level
    end
  end
end
