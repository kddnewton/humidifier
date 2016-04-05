require 'test_helper'

module Props
  class BaseTest < Minitest::Test

    def test_name_conversion
      base = AwsCF::Props::Base.new('MyTestKey')
      assert_equal 'my_test_key', base.name
    end

    def test_to_cf
      base, value = AwsCF::Props::Base.new('MyTestKey'), Object.new
      assert_equal ['MyTestKey', value], base.to_cf(value)
    end

    def test_to_cf_ref
      base = AwsCF::Props::Base.new('MyTestKey')
      reference = Object.new
      assert_equal ['MyTestKey', { 'Ref' => reference }], base.to_cf(AwsCF::Ref.new(reference))
    end
  end
end
