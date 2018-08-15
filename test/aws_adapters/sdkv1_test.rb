# frozen_string_literal: true

require 'test_helper'

class SDKV1Test < Minitest::Test
  def test_create_change_set
    with_sdk_v1_loaded do |sdk|
      out, * = capture_io { refute sdk.create_change_set }
      assert_match(/WARNING/, out)
    end
  end

  def test_deploy_change_set
    with_sdk_v1_loaded do |sdk|
      out, * = capture_io { refute sdk.deploy_change_set }
      assert_match(/WARNING/, out)
    end
  end

  def test_exists?
    with_sdk_v1_loaded do |sdk|
      SdkSupport.expect(:exists?, [], true)
      assert sdk.exists?(payload(identifier: 'testing'))
      SdkSupport.verify
    end
  end

  def test_exists_false
    with_sdk_v1_loaded do |sdk|
      SdkSupport.expect(:exists?, [], false)
      refute sdk.exists?(payload(identifier: 'testing'))
      SdkSupport.verify
    end
  end

  def test_create_and_wait
    with_sdk_v1_loaded do |sdk|
      arguments = [{ stack_name: 'name', template_body: 'body' }]
      SdkSupport.expect(:create_stack, arguments, stub(stack_id: 'tid'))

      response = stub(stacks: [stub(stack_status: 'CREATE_COMPLETE')])
      SdkSupport.expect(:describe_stacks, [{ stack_name: 'tid' }], response)

      create_payload =
        payload(name: 'name', to_cf: 'body', identifier: 'tid', max_wait: 10)

      sdk.create_and_wait(create_payload)
      SdkSupport.verify
    end
  end

  def test_create_and_wait_failure
    with_sdk_v1_loaded do |sdk|
      create_and_wait_failure_expectations
      create_payload =
        payload(name: 'name', to_cf: 'body', identifier: 'tid', max_wait: 10)

      error = assert_raises { sdk.create_and_wait(create_payload) }
      assert_equal "name stack failed:\nfailure", error.message
      SdkSupport.verify
    end
  end

  def test_upload
    with_config(s3_bucket: 'test.s3.bucket') do
      with_sdk_v1_loaded do |sdk|
        upload_expectations
        sdk.upload(payload(identifier: 'identifier', to_cf: 'body'))
        SdkSupport.verify
      end
    end
  end

  private

  def create_and_wait_failure_expectations
    arguments = [{ stack_name: 'name', template_body: 'body' }]
    SdkSupport.expect(:create_stack, arguments, stub(stack_id: 'tid'))

    describe_response = stub(stacks: [stub(stack_status: 'FAILED')])
    arguments = [{ stack_name: 'tid' }]
    SdkSupport.expect(:describe_stacks, arguments, describe_response)

    stack_events =
      [stub(resource_status: 'FAILED', resource_status_reason: 'failure')]
    events_response = stub(stack_events: stack_events)

    arguments = [{ stack_name: 'tid' }]
    SdkSupport.expect(:describe_stack_events, arguments, events_response)
  end

  def upload_expectations
    SdkSupport.expect(:config, [region: Humidifier::AwsShim::REGION])
    SdkSupport.expect(:new, [], SdkSupport.double)
    SdkSupport.expect(:buckets, [], 'test.s3.bucket' => SdkSupport.double)
    SdkSupport.expect(:objects, [], SdkSupport.double)
    SdkSupport.expect(:create, ['identifier.json', 'body'], SdkSupport.double)
    SdkSupport.expect(:url_for, [:read])
  end
end
