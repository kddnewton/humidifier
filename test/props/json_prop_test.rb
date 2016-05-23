require 'test_helper'

module Props
  class JSONPropTest < Minitest::Test

    def test_valid?
      assert Humidifier::Props::JSONProp.new.valid?({})
      assert Humidifier::Props::StringProp.new.valid?(Humidifier.ref(Object.new))
      assert Humidifier::Props::StringProp.new.valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute Humidifier::Props::JSONProp.new.valid?(Object.new)
      refute Humidifier::Props::JSONProp.new.valid?('{}')
      refute Humidifier::Props::JSONProp.new.valid?(1)
    end
  end
end
