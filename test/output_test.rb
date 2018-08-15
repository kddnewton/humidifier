# frozen_string_literal: true

require 'test_helper'

class OutputTest < Minitest::Test
  def test_to_cf
    with_mocked_serializer(Object.new) do |value|
      expected = { 'Value' => value }
      assert_equal expected, Humidifier::Output.new(value: value).to_cf
    end
  end

  def test_to_cf_with_description
    with_mocked_serializer(Object.new) do |value|
      output = Humidifier::Output.new(value: value, description: 'foobar')
      expected = { 'Value' => value, 'Description' => 'foobar' }
      assert_equal expected, output.to_cf
    end
  end

  def test_to_cf_with_export_name
    with_mocked_serializer(Object.new) do |value|
      output = Humidifier::Output.new(value: value, export_name: 'foobar')
      expected = { 'Value' => value, 'Export' => { 'Name' => 'foobar' } }
      assert_equal expected, output.to_cf
    end
  end
end
