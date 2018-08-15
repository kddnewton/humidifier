# frozen_string_literal: true

require 'test_helper'

class SDKV2Test < Minitest::Test
  def test_create_change_set
    with_sdk_v2_loaded do |sdk|
      SdkSupport.expect(:create_change_set, [change_set_options])
      Time.stub(:now, Time.at(0)) do
        assert sdk.create_change_set(payload(identifier: 'name', to_cf: 'body'))
      end
      SdkSupport.verify
    end
  end

  def test_deploy_change_set_exists
    with_sdk_v2_loaded do |sdk|
      SdkSupport.expect(:exists?, [], true)
      SdkSupport.expect(:create_change_set, [change_set_options])

      Time.stub(:now, Time.at(0)) do
        assert sdk.deploy_change_set(payload(identifier: 'name', to_cf: 'body'))
      end
      SdkSupport.verify
    end
  end

  def test_deploy_change_set_does_not_exist
    with_sdk_v2_loaded do |sdk|
      SdkSupport.expect(:exists?, [], false)

      arguments = [{ stack_name: 'name', template_body: 'body' }]
      SdkSupport.expect(:create_stack, arguments, stub(stack_id: 'test-id'))

      assert sdk.deploy_change_set(payload(name: 'name', to_cf: 'body'))
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
      expect_create_and_wait

      create_payload =
        payload(name: 'name', to_cf: 'body', identifier: 'tid', max_wait: 10)
      sdk.create_and_wait(create_payload)

      SdkSupport.verify
    end
  end

  def test_upload
    with_config(s3_bucket: 'test.s3.bucket') do
      with_sdk_v2_loaded do |sdk|
        expect_upload
        sdk.upload(payload(identifier: 'identifier', to_cf: 'body'))
        SdkSupport.verify
      end
    end
  end

  private

  def change_set_options
    change_set_name = "changeset-#{Time.at(0).strftime('%Y-%m-%d-%H-%M-%S')}"

    {
      stack_name: 'name',
      template_body: 'body',
      change_set_name: change_set_name
    }
  end

  def expect_create_and_wait
    arguments = [{ stack_name: 'name', template_body: 'body' }]
    SdkSupport.expect(:create_stack, arguments, stub(stack_id: 'tid'))

    arguments = [:stack_create_complete, stack_name: 'tid']
    SdkSupport.expect(:wait_until, arguments)

    SdkSupport.expect(:max_attempts=, [Humidifier::SdkPayload::MAX_WAIT / 5])
    SdkSupport.expect(:delay=, [5])
  end

  def expect_upload
    SdkSupport.expect(:config, [], SdkSupport.double)
    SdkSupport.expect(:update, [region: Humidifier::AwsShim::REGION])

    arguments =
      [body: 'body', bucket: 'test.s3.bucket', key: 'identifier.json']
    SdkSupport.expect(:put_object, arguments)

    SdkSupport.expect(:presigned_url, [:get])
  end
end
