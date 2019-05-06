# frozen_string_literal: true

require 'test_helper'

class MappingTest < Minitest::Test
  def test_to_cf
    value = {}

    assert_equal value, Humidifier::Mapping.new(value).to_cf
  end

  def test_to_cf_with_opts
    value = { foo: 'bar', bar: 'baz' }

    assert_equal value, Humidifier::Mapping.new(value).to_cf
  end
end
