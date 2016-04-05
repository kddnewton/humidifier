require 'test_helper'

module Props
  class BaseTest < Minitest::Test

    def test_name_conversion
      base = AwsCF::Props::Base.new(key: 'MyTestKey')
      assert_equal 'my_test_key', base.name
    end

    def test_to_cf
      base, value = AwsCF::Props::Base.new(key: 'MyTestKey'), Object.new
      assert_equal ['MyTestKey', value], base.to_cf(value)
    end
  end
end
