# frozen_string_literal: true

require 'test_helper'

module Props
  class BaseTest < Minitest::Test
    class TestProp < Humidifier::Props::Base
      def convert; end
    end

    def test_name_conversion
      assert_equal 'my_test_key', build('MyTestKey').name
    end

    def test_to_cf
      base = build('MyTestKey')
      value = Object.new

      mock = Minitest::Mock.new
      mock.expect(:call, value, [value])

      Humidifier::Serializer.stub(:dump, mock) do
        assert_equal ['MyTestKey', value], base.to_cf(value)
      end
      mock.verify
    end

    def test_documentation
      prop = build('Test', 'Documentation' => 'documentation')
      assert_equal 'documentation', prop.documentation
    end

    def test_required?
      assert build('Test', 'Required' => true).required?
    end

    def test_update_type
      prop = build('Test', 'UpdateType' => 'update_type')
      assert_equal 'update_type', prop.update_type
    end

    def test_whitelisted_value?
      base = build
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

    def build(key = 'Test', spec = {})
      Humidifier::Props::Base.new(key, spec)
    end

    def suppress_warnings
      warn_level = $VERBOSE
      $VERBOSE = nil
      yield
      $VERBOSE = warn_level
    end
  end
end
