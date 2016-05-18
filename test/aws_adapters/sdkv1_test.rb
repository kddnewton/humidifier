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
      create_payload = payload(name: 'name', to_cf: 'body', identifier: 'test-id')

      describe_response = stub(stacks: [stub(stack_status: 'CREATE_COMPLETE')])
      SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))
      SdkStubber.expect(:describe_stacks, [{ stack_name: 'test-id' }], describe_response)

      sdk.create_and_wait(create_payload)
      SdkStubber.verify
    end
  end
end
