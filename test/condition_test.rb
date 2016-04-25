require 'test_helper'

class ConditionTest < Minitest::Test

  def test_to_cf
    with_mocked_serializer({}) do |value|
      assert_equal value, Humidifier::Condition.new(value).to_cf
    end
  end

  def test_to_cf_with_opts
    with_mocked_serializer(foo: 'bar', bar: 'baz') do |value|
      output = Humidifier::Condition.new(value)
      assert_equal value, output.to_cf
    end
  end
end
