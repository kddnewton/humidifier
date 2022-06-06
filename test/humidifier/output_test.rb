# frozen_string_literal: true

require "test_helper"

module Humidifier
  class OutputTest < Minitest::Test
    def test_to_cf
      value = Object.new

      expected = { "Value" => value }
      actual = Output.new(value: value).to_cf

      assert_equal expected, actual
    end

    def test_to_cf_with_description
      value = Object.new

      expected = { "Value" => value, "Description" => "foobar" }
      actual = Output.new(value: value, description: "foobar").to_cf

      assert_equal expected, actual
    end

    def test_to_cf_with_export_name
      value = Object.new

      expected = { "Value" => value, "Export" => { "Name" => "foobar" } }
      actual = Output.new(value: value, export_name: "foobar").to_cf

      assert_equal expected, actual
    end
  end
end
