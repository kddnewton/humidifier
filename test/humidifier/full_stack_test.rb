# frozen_string_literal: true

require "test_helper"

module Humidifier
  class FullStackTest < Minitest::Test
    Resource = Struct.new(:to_cf)
    EXPECTED_CF = {
      "AWSTemplateFormatVersion" => "foo",
      "Description" => "bar",
      "Metadata" => "baz",
      "Resources" => {
        "One" => "One",
        "Two" => "Two"
      },
      "Mappings" => {
        "Three" => "Three"
      },
      "Outputs" => {
        "Four" => "Four"
      },
      "Parameters" => {
        "Five" => "Five"
      },
      "Conditions" => {
        "Six" => "Six"
      }
    }.freeze

    def test_to_cf
      stack =
        Stack.new(
          aws_template_format_version: "foo",
          description: "bar",
          metadata: "baz",
          resources: {
            "One" => Resource.new("One"),
            "Two" => Resource.new("Two")
          },
          mappings: {
            "Three" => Resource.new("Three")
          },
          outputs: {
            "Four" => Resource.new("Four")
          },
          parameters: {
            "Five" => Resource.new("Five")
          },
          conditions: {
            "Six" => Resource.new("Six")
          }
        )

      assert_equal EXPECTED_CF, JSON.parse(stack.to_cf(:json))
      assert_equal EXPECTED_CF, YAML.safe_load(stack.to_cf(:yaml))
    end
  end
end
