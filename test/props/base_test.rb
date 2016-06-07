require 'test_helper'

module Props
  class BaseTest < Minitest::Test
    class TestProp < Humidifier::Core::Props::Base
      def convert; end
    end

    def test_name_conversion
      base = Humidifier::Core::Props::Base.new('MyTestKey')
      assert_equal 'my_test_key', base.name
    end

    def test_to_cf
      base = Humidifier::Core::Props::Base.new('MyTestKey')
      value = Object.new

      mock = Minitest::Mock.new
      mock.expect(:call, value, [value])

      Humidifier::Core::Serializer.stub(:dump, mock) do
        assert_equal ['MyTestKey', value], base.to_cf(value)
      end
      mock.verify
    end

    def test_convertable?
      refute Humidifier::Core::Props::Base.new.convertable?
      assert TestProp.new.convertable?
    end

    def test_whitelisted_value?
      base = Humidifier::Core::Props::Base.new
      original_whitelist = Humidifier::Core::Props::Base::WHITELIST

      suppress_warnings do
        Humidifier::Core::Props::Base.const_set(:WHITELIST, [])
        refute base.whitelisted_value?('test')

        Humidifier::Core::Props::Base::WHITELIST << String
        assert base.whitelisted_value?('test')

        Humidifier::Core::Props::Base.const_set(:WHITELIST, original_whitelist)
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
