require 'test_helper'

module Props
  class JSONPropTest < Minitest::Test

    def test_valid?
      assert valid?({})
      assert valid?(Humidifier.ref(Object.new))
      assert valid?(Humidifier.fn.base64(Object.new))
    end

    def test_rejects_other_values
      refute valid?(Object.new)
      refute valid?('{}')
      refute valid?(1)
    end

    private

    def valid?(object)
      Humidifier::Core::Props::JSONProp.new.valid?(object)
    end
  end
end
