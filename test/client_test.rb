# frozen_string_literal: true

require 'test_helper'

class ClientTest < Minitest::Test
  class WaitingClient < SimpleDelegator
    attr_accessor :max_attempts, :delay

    def wait_until(*)
      yield self
    end
  end

  def test_create
    Aws.config[:cloudformation] = {
      stub_responses: { create_stack: { stack_id: 'test-id' } }
    }

    stack = build_stack
    stack.create

    assert_equal 'test-id', stack.id
  end

  def test_create_and_wait
    Aws.config[:cloudformation] = {
      stub_responses: { create_stack: { stack_id: 'test-id' } }
    }

    build_stack.create_and_wait
  end

  def test_create_change_set
    Aws.config[:cloudformation] = {
      stub_responses: { create_change_set: true }
    }

    build_stack.create_change_set
  end

  def test_delete
    Aws.config[:cloudformation] = {
      stub_responses: { delete_stack: true }
    }

    build_stack.delete
  end

  def test_delete_and_wait
    Aws.config[:cloudformation] = {
      stub_responses: { delete_stack: true }
    }

    build_stack.delete_and_wait
  end

  def test_deploy_exists
    Aws.config[:cloudformation] = {
      stub_responses: { update_stack: true }
    }

    with_stack_status(true) { build_stack.deploy }
  end

  def test_deploy_does_not_exists
    Aws.config[:cloudformation] = {
      stub_responses: { create_stack: { stack_id: 'test-id' } }
    }

    stack = build_stack
    with_stack_status(false) { stack.deploy }

    assert_equal 'test-id', stack.id
  end

  def test_deploy_and_wait
    Aws.config[:cloudformation] = {
      stub_responses: { update_stack: true }
    }

    with_stack_status(true) { build_stack.deploy_and_wait }
  end

  def test_deploy_change_set_exists
    Aws.config[:cloudformation] = {
      stub_responses: { create_change_set: true }
    }

    with_stack_status(true) { build_stack.deploy_change_set }
  end

  def test_deploy_change_set_does_not_exist
    Aws.config[:cloudformation] = {
      stub_responses: { create_stack: { stack_id: 'stack-id' } }
    }

    with_stack_status(false) { build_stack.deploy_change_set }
  end

  def test_update
    Aws.config[:cloudformation] = {
      stub_responses: { update_stack: true }
    }

    build_stack.update
  end

  def test_update_and_wait
    Aws.config[:cloudformation] = {
      stub_responses: { update_stack: true }
    }

    build_stack.update_and_wait
  end

  def test_valid?
    Aws.config[:cloudformation] = {
      stub_responses: { validate_template: true }
    }

    assert build_stack.valid?
  end

  private

  def build_stack
    Humidifier::Stack.new(name: 'stack-name').tap do |stack|
      asg = Humidifier::AutoScaling::AutoScalingGroup
      stack.add('asg', asg.new(min_size: '1', max_size: '20'))
      stack.client = WaitingClient.new(stack.client)
    end
  end

  def with_stack_status(exists, &block)
    stack = Struct.new(:exists?).new(exists)
    Aws::CloudFormation::Stack.stub(:new, stack, &block)
  end
end
