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

    def test_to_cf_nested
      base = AwsCF::Props::Base.new('MyTestKey')
      reference1, reference2 = Object.new, Object.new
      value = [{ 'Container' => AwsCF::Ref.new(reference1) }, AwsCF::Ref.new(reference2)]

      expected = ['MyTestKey', [{ 'Container' => { 'Ref' => reference1 } }, { 'Ref' => reference2 }]]
      assert_equal expected, base.to_cf(value)
    end
  end
end
