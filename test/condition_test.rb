# frozen_string_literal: true

require 'test_helper'

class ConditionTest < Minitest::Test
  def test_to_cf
    value = {}

    assert_equal value, Humidifier::Condition.new(value).to_cf
  end

  def test_to_cf_with_opts
    value = { foo: 'bar', bar: 'baz' }

    assert_equal value, Humidifier::Condition.new(value).to_cf
  end
end
