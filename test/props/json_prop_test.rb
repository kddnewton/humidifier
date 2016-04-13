require 'test_helper'

module Props
  class JSONPropTest < Minitest::Test

    def test_takes_hash
      assert Humidifier::Props::JSONProp.new.valid?({})
    end

    def test_rejects_other_values
      refute Humidifier::Props::JSONProp.new.valid?(Object.new)
      refute Humidifier::Props::JSONProp.new.valid?([])
      refute Humidifier::Props::JSONProp.new.valid?('{}')
      refute Humidifier::Props::JSONProp.new.valid?(1)
    end
  end
end
