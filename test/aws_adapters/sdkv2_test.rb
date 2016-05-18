require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_exists?
    with_sdk_v2_loaded do |sdk|
      SdkStubber.expect(:exists?, [], true)
      assert sdk.exists?(payload(identifier: 'testing'))
      SdkStubber.verify
    end
  end

  def test_exists_false
    with_sdk_v2_loaded do |sdk|
      SdkStubber.expect(:exists?, [], false)
      refute sdk.exists?(payload(identifier: 'testing'))
      SdkStubber.verify
    end
  end

  def test_create_and_wait
    with_sdk_v2_loaded do |sdk|
      create_payload = payload(name: 'name', to_cf: 'body', identifier: 'test-id')

      SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))
      SdkStubber.expect(:wait_until, [:stack_create_complete, stack_name: 'test-id'])

      sdk.create_and_wait(create_payload)
      SdkStubber.verify
    end
  end
end
