require 'test_helper'

module Props
  class IntegerPropTest < Minitest::Test

    def test_takes_fixnum
      assert Humidifier::Props::IntegerProp.new.valid?(1)
    end

    def test_rejects_other_values
      refute Humidifier::Props::IntegerProp.new.valid?(Object.new)
      refute Humidifier::Props::IntegerProp.new.valid?([])
      refute Humidifier::Props::IntegerProp.new.valid?({})
      refute Humidifier::Props::IntegerProp.new.valid?(1.0)
    end
  end
end
