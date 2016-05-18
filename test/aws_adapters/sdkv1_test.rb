require 'test_helper'

class SDKV1Test < Minitest::Test

  def test_exists?
    with_sdk_v1_loaded do |sdk|
      SdkStubber.expect(:exists?, [], true)
      assert sdk.exists?(payload(identifier: 'testing'))
      SdkStubber.verify
    end
  end

  def test_exists_false
    with_sdk_v1_loaded do |sdk|
      SdkStubber.expect(:exists?, [], false)
      refute sdk.exists?(payload(identifier: 'testing'))
      SdkStubber.verify
    end
  end

  def test_create_and_wait
    with_sdk_v1_loaded do |sdk|
      SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))
      describe_response = stub(stacks: [stub(stack_status: 'CREATE_COMPLETE')])
      SdkStubber.expect(:describe_stacks, [{ stack_name: 'test-id' }], describe_response)

      sdk.create_and_wait(payload(name: 'name', to_cf: 'body', identifier: 'test-id', max_wait: 10))
      SdkStubber.verify
    end
  end

  def test_create_and_wait_failure
    with_sdk_v1_loaded do |sdk|
      create_and_wait_failure_expectations
      create_payload = payload(name: 'name', to_cf: 'body', identifier: 'test-id', max_wait: 10)

      error = assert_raises { sdk.create_and_wait(create_payload) }
      assert_equal "name stack failed:\nfailure", error.message
      SdkStubber.verify
    end
  end

  private

  def create_and_wait_failure_expectations
    SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))

    describe_response = stub(stacks: [stub(stack_status: 'FAILED')])
    SdkStubber.expect(:describe_stacks, [{ stack_name: 'test-id' }], describe_response)

    events_response = stub(stack_events: [stub(resource_status: 'FAILED', resource_status_reason: 'failure')])
    SdkStubber.expect(:describe_stack_events, [{ stack_name: 'test-id' }], events_response)
  end
end
