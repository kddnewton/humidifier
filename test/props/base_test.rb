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

      Humidifier::Serializer.stub(:dump, mock) do
        assert_equal ['MyTestKey', value], base.to_cf(value)
      end
      mock.verify
    end

    def test_convertable?
      refute Humidifier::Props::Base.new.convertable?
      assert TestProp.new.convertable?
    end
  end
end
