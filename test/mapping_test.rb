# frozen_string_literal: true

require 'test_helper'

class MappingTest < Minitest::Test
  def test_to_cf
    with_mocked_serializer({}) do |value|
      assert_equal value, Humidifier::Mapping.new(value).to_cf
    end
  end

  def test_to_cf_with_opts
    with_mocked_serializer(foo: 'bar', bar: 'baz') do |value|
      output = Humidifier::Mapping.new(value)
      assert_equal value, output.to_cf
    end
  end
end
