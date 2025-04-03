# frozen_string_literal: true

require "test_helper"

module Humidifier
  class ClientTest < Minitest::Test
    def test_create_change_set_no_resources
      assert_raises(Stack::NoResourcesError) do
        Stack.new(name: "stack-name").create_change_set
      end
    end

    def test_deploy_no_resources
      assert_raises(Stack::NoResourcesError) do
        Stack.new(name: "stack-name").deploy
      end
    end

    def test_upload_no_resources
      assert_raises(Stack::NoResourcesError) do
        Stack.new(name: "stack-name").upload
      end
    end

    def test_create
      Aws.config[:cloudformation] = {
        stub_responses: {
          create_stack: [{ stack_id: "stack-id" }]
        }
      }

      stack = build_stack
      stack.create

      assert_equal "stack-id", stack.id
    end

    def test_create_change_set
      Aws.config[:cloudformation] = {
        stub_responses: {
          create_change_set: [{}]
        }
      }

      build_stack.create_change_set
    end

    def test_delete
      Aws.config[:cloudformation] = { stub_responses: { delete_stack: [{}] } }

      build_stack.delete
    end

    def test_deploy_exists
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks("CREATE_COMPLETE"),
          update_stack: [{}]
        }
      }

      build_stack.deploy
    end

    def test_deploy_does_not_exist
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks(nil),
          create_stack: [{ stack_id: "stack-id" }]
        }
      }

      stack = build_stack
      stack.deploy

      assert_equal "stack-id", stack.id
    end

    def test_deploy_change_set_exists
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks("CREATE_COMPLETE"),
          create_change_set: [{}]
        }
      }

      build_stack.deploy_change_set
    end

    def test_deploy_change_set_does_not_exist
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks(nil),
          create_stack: [{}]
        }
      }

      build_stack.deploy_change_set
    end

    def test_update
      Aws.config[:cloudformation] = { stub_responses: { update_stack: [{}] } }

      build_stack.update
    end

    def test_upload_no_config
      error =
        assert_raises(Stack::UploadNotConfiguredError) { build_stack.upload }

      assert_includes error.message, "stack-name"
    end

    def test_upload_with_config
      Aws.config[:s3] = {
        stub_responses: {
          get_object: [{}],
          put_object: [{}]
        }
      }

      with_config(s3_bucket: "foobar") { build_stack.upload }
    end

    def test_valid_true
      Aws.config[:cloudformation] = {
        stub_responses: {
          validate_template: [{}]
        }
      }

      assert build_stack.valid?
    end

    def test_valid_false
      Aws.config[:cloudformation] = {
        stub_responses: {
          validate_template: [
            Aws::CloudFormation::Errors::ValidationError.new(nil, "validation")
          ]
        }
      }

      io = capture_io { refute build_stack.valid? }
      assert io[1].start_with?("validation")
    end

    def test_valid_bad_permissions
      Aws.config[:cloudformation] = {
        stub_responses: {
          validate_template: [
            Aws::CloudFormation::Errors::AccessDenied.new(nil, nil)
          ]
        }
      }

      assert_raises(Error) { build_stack.valid? }
    end

    def test_valid_upload_necessary
      Aws.config.merge!(
        s3: {
          stub_responses: {
            get_object: [{}],
            put_object: [{}]
          }
        },
        cloudformation: {
          stub_responses: {
            validate_template: [{}]
          }
        }
      )

      stack = build_stack
      stack.add(
        "a" * Stack::MAX_TEMPLATE_BODY_SIZE,
        stack.resources.delete("asg")
      )

      with_config(s3_bucket: "foobar") { assert stack.valid? }
    end

    def test_valid_stack_too_large
      stack = build_stack
      stack.add(
        "a" * Stack::MAX_TEMPLATE_URL_SIZE,
        stack.resources.delete("asg")
      )

      assert_raises(Stack::TemplateTooLargeError) { stack.valid? }
    end

    def test_create_and_wait
      Aws.config[:cloudformation] = {
        stub_responses: {
          create_stack: [{}],
          describe_stacks: describe_stacks("CREATE_COMPLETE")
        }
      }

      build_stack.create_and_wait
    end

    def test_delete_and_wait
      Aws.config[:cloudformation] = {
        stub_responses: {
          delete_stack: [{}],
          describe_stacks: describe_stacks("DELETE_COMPLETE")
        }
      }

      build_stack.delete_and_wait
    end

    def test_deploy_and_wait_does_not_exist
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks(nil, "CREATE_COMPLETE"),
          create_stack: [{}]
        }
      }

      build_stack.deploy_and_wait
    end

    def test_deploy_and_wait_exists
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks:
            describe_stacks("CREATE_COMPLETE", "UPDATE_COMPLETE"),
          update_stack: [{}]
        }
      }

      build_stack.deploy_and_wait
    end

    def test_update_and_wait
      Aws.config[:cloudformation] = {
        stub_responses: {
          describe_stacks: describe_stacks("UPDATE_COMPLETE"),
          update_stack: [{}]
        }
      }

      build_stack.update_and_wait
    end

    private

    def build_stack
      stack = Stack.new(name: "stack-name")
      stack.add(
        "asg",
        AutoScaling::AutoScalingGroup.new(min_size: "1", max_size: "20")
      )
      stack
    end

    def describe_stacks(*responses)
      responses.map do |response|
        if response
          {
            stacks: [
              {
                stack_status: response,
                stack_name: "stack-name",
                creation_time: Time.now
              }
            ]
          }
        else
          Aws::CloudFormation::Errors::ValidationError.new(nil, "validation")
        end
      end
    end
  end
end
