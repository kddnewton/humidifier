require 'test_helper'

module Props
  class ArrayPropTest < Minitest::Test

    def test_takes_array
      assert build.valid?(%w[one two three])
    end

    def test_rejects_other_values
      refute build.valid?(Object.new)
      refute build.valid?(1)
    end

    private

      def build
        Humidifier::Props::ArrayProp.new(key: 'MyTestKey', spec: 'String')
      end
  end
end
