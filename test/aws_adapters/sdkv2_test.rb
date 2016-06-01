require 'test_helper'

class SDKV2Test < Minitest::Test

  def test_create_change_set
    with_sdk_v2_loaded do |sdk|
      change_set_name = "changeset-#{Time.at(0).strftime('%Y-%m-%d-%H-%M-%S')}"
      options = { stack_name: 'name', template_body: 'body', change_set_name: change_set_name }
      SdkSupport.expect(:create_change_set, [options])

      Time.stub(:now, Time.at(0)) do
        assert sdk.create_change_set(payload(identifier: 'name', to_cf: 'body'))
      end

      SdkSupport.verify
    end
  end

  def test_exists?
    with_sdk_v2_loaded do |sdk|
      SdkSupport.expect(:exists?, [], true)
      assert sdk.exists?(payload(identifier: 'testing'))
      SdkSupport.verify
    end
  end

  def test_exists_false
    with_sdk_v2_loaded do |sdk|
      SdkSupport.expect(:exists?, [], false)
      refute sdk.exists?(payload(identifier: 'testing'))
      SdkSupport.verify
    end
  end

  def test_create_and_wait
    with_sdk_v2_loaded do |sdk|
      create_payload = payload(name: 'name', to_cf: 'body', identifier: 'test-id', max_wait: 10)

      SdkSupport.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))
      SdkSupport.expect(:wait_until, [:stack_create_complete, stack_name: 'test-id'])
      SdkSupport.expect(:max_attempts=, [2])
      SdkSupport.expect(:delay=, [5])

      sdk.create_and_wait(create_payload)
      SdkSupport.verify
    end
  end
end
