require 'test_helper'

module Props
  class JSONPropTest < Minitest::Test

    def test_takes_hash
      assert AwsCF::Props::JSONProp.new.valid?({})
    end

    def test_rejects_other_values
      refute AwsCF::Props::JSONProp.new.valid?(Object.new)
      refute AwsCF::Props::JSONProp.new.valid?([])
      refute AwsCF::Props::JSONProp.new.valid?('{}')
      refute AwsCF::Props::JSONProp.new.valid?(1)
    end
  end
end
