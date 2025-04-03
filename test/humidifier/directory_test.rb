# frozen_string_literal: true

require "test_helper"

module Humidifier
  class DirectoryTest < Minitest::Test
    def test_create_change_set
      Aws.config[:cloudformation] = {
        stub_responses: {
          create_change_set: [{}],
          validate_template: [{}]
        }
      }

      Directory.new("alpha").create_change_set
    end

    def test_deploy
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: [
            Aws::CloudFormation::Errors::ValidationError.new(nil, "validation")
          ],
          create_stack: [{}],
          validate_template: [{}]
        }
      }

      Directory.new("alpha").deploy
    end

    def test_upload
      Aws.config[:s3] = {
        stub_responses: {
          get_object: [{}],
          put_object: [{}]
        }
      }

      Aws.config[:cloudformation] = {
        stub_responses: {
          validate_template: [{}]
        }
      }

      with_config(s3_bucket: "foobar") { Directory.new("alpha").upload }
    end

    def test_exports
      outputs = JSON.parse(Directory.new("alpha").to_cf)["Outputs"]

      expected = "AlphaUser1"
      assert_equal expected, outputs.keys.first

      output =
        Output.new(value: Humidifier.ref(expected), export_name: expected)

      assert_equal output.to_cf, outputs[expected]
    end

    def test_export_attributes
      outputs = JSON.parse(Directory.new("alpha").to_cf)["Outputs"]

      expected = Humidifier.fn.get_att(%w[AlphaUser2 Arn]).to_cf
      assert_equal expected, outputs.dig("AlphaUser2", "Value")
    end

    def test_parameters
      parameters = JSON.parse(Directory.new("alpha").to_cf)["Parameters"]
      default_values = parameters.values.map { |value| value["Default"] }

      assert_equal 2, parameters.size
      assert_equal %w[One Two], default_values
    end

    def test_stack_name
      assert_equal "humidifier-alpha", Directory.new("alpha").stack_name
    end

    def test_to_cf
      resources = JSON.parse(Directory.new("alpha").to_cf)["Resources"]
      assert_equal RESOURCE_NAMES, resources.keys.sort

      names = resources.map { |_, config| config["Properties"]["UserName"] }
      assert_equal RESOURCE_NAMES, names.sort
    end
  end
end
