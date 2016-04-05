require 'test_helper'

module Props
  class BooleanPropTest < Minitest::Test

    def test_takes_true
      assert AwsCF::Props::BooleanProp.new.valid?(true)
    end

    def test_takes_false
      assert AwsCF::Props::BooleanProp.new.valid?(false)
    end

    def test_rejects_other_values
      refute AwsCF::Props::BooleanProp.new.valid?(Object.new)
      refute AwsCF::Props::BooleanProp.new.valid?([])
      refute AwsCF::Props::BooleanProp.new.valid?({})
      refute AwsCF::Props::BooleanProp.new.valid?(1)
    end
  end
end
