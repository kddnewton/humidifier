require 'test_helper'

module Props
  class BaseTest < Minitest::Test

    def test_name_conversion
      base = Humidifier::Props::Base.new('MyTestKey')
      assert_equal 'my_test_key', base.name
    end

    def test_to_cf
      base, value = Humidifier::Props::Base.new('MyTestKey'), Object.new
      assert_equal ['MyTestKey', value], base.to_cf(value)
    end

    def test_to_cf_nested
      base = Humidifier::Props::Base.new('MyTestKey')
      reference1, reference2 = Object.new, Object.new
      value = [{ 'Container' => Humidifier.ref(reference1) }, Humidifier.fn.base64(Humidifier.ref(reference2))]

      expected = ['MyTestKey', [{ 'Container' => { 'Ref' => reference1 } }, { 'Fn::Base64' => { 'Ref' => reference2 } }]]
      assert_equal expected, base.to_cf(value)
    end
  end
end
