require 'test_helper'

module Props
  class StringPropTest < Minitest::Test

    def test_takes_string
      assert AwsCF::Props::StringProp.new.valid?('value')
    end

    def test_rejects_other_values
      refute AwsCF::Props::StringProp.new.valid?(Object.new)
      refute AwsCF::Props::StringProp.new.valid?([])
      refute AwsCF::Props::StringProp.new.valid?({})
      refute AwsCF::Props::StringProp.new.valid?(1)
    end
  end
end
