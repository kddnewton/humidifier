require 'test_helper'

module Props
  class StringPropTest < Minitest::Test

    def test_takes_string
      assert Humidifier::Props::StringProp.new.valid?('value')
    end

    def test_takes_ref
      assert Humidifier::Props::StringProp.new.valid?(Humidifier::Ref.new(Object.new))
    end

    def test_rejects_other_values
      refute Humidifier::Props::StringProp.new.valid?(Object.new)
      refute Humidifier::Props::StringProp.new.valid?([])
      refute Humidifier::Props::StringProp.new.valid?({})
      refute Humidifier::Props::StringProp.new.valid?(1)
    end
  end
end
