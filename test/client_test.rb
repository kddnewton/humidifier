# frozen_string_literal: true

require 'test_helper'

class ClientTest < Minitest::Test
  def test_create
    Aws.config[:cloudformation] = {
      stub_responses: { create_stack: { stack_id: 'test-id' } }
    }

    stack = build_stack
    stack.create

    assert_equal 'test-id', stack.id
  end

  def test_delete
    Aws.config[:cloudformation] = {
      stub_responses: { delete_stack: true }
    }

    build_stack.delete
  end

  def test_update
    Aws.config[:cloudformation] = {
      stub_responses: { update_stack: true }
    }

    build_stack.update
  end

  def test_valid?
    Aws.config[:cloudformation] = {
      stub_responses: { validate_template: true }
    }

    assert build_stack.valid?
  end

  private

  def build_stack
    asg =
      Humidifier::AutoScaling::AutoScalingGroup.new(
        min_size: '1',
        max_size: '20'
      )

    Humidifier::Stack.new(name: 'stack-name', resources: { 'asg' => asg })
  end
end
