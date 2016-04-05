require 'test_helper'

module Props
  class IntegerPropTest < Minitest::Test

    def test_takes_fixnum
      assert AwsCF::Props::IntegerProp.new.valid?(1)
    end

    def test_rejects_other_values
      refute AwsCF::Props::IntegerProp.new.valid?(Object.new)
      refute AwsCF::Props::IntegerProp.new.valid?([])
      refute AwsCF::Props::IntegerProp.new.valid?({})
      refute AwsCF::Props::IntegerProp.new.valid?(1.0)
    end
  end
end
