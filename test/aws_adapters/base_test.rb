require 'test_helper'

class BaseTest < Minitest::Test

  def test_validation_error
    create_payload = Object.new
    def create_payload.name
      raise SdkStubber::AwsDouble::CloudFormation::Errors::ValidationError, 'test-error'
    end

    with_both_sdks do |sdk|
      _, stderr = capture_io { refute sdk.create(create_payload) }
      assert_equal 'test-error', stderr.split.first
    end
  end

  def test_create
    with_both_sdks do |sdk|
      create_payload = payload(name: 'name', to_cf: 'body')
      SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))

      sdk.create(create_payload)
      assert_equal 'test-id', create_payload.id
      SdkStubber.verify
    end
  end

  def test_delete
    with_both_sdks do |sdk|
      SdkStubber.expect(:delete_stack, [{ stack_name: 'identifier' }])
      sdk.delete(payload(identifier: 'identifier'))
      SdkStubber.verify
    end
  end

  def test_deploy_exists
    with_both_sdks do |sdk|
      SdkStubber.expect(:exists?, [], true)
      SdkStubber.expect(:update_stack, [{ stack_name: 'name', template_body: 'body' }])

      sdk.deploy(payload(identifier: 'name', to_cf: 'body'))
      SdkStubber.verify
    end
  end

  def test_deploy_does_not_exist
    with_both_sdks do |sdk|
      deploy_payload = payload(name: 'name', to_cf: 'body')
      SdkStubber.expect(:exists?, [], false)
      SdkStubber.expect(:create_stack, [{ stack_name: 'name', template_body: 'body' }], stub(stack_id: 'test-id'))

      sdk.deploy(deploy_payload)
      assert_equal 'test-id', deploy_payload.id
      SdkStubber.verify
    end
  end

  def test_update
    with_both_sdks do |sdk|
      SdkStubber.expect(:update_stack, [{ stack_name: 'name', template_body: 'body' }])
      sdk.update(payload(identifier: 'name', to_cf: 'body'))
      SdkStubber.verify
    end
  end

  def test_valid?
    with_both_sdks do |sdk|
      SdkStubber.expect(:validate_template, [{ template_body: 'body' }])
      sdk.valid?(payload(to_cf: 'body'))
      SdkStubber.verify
    end
  end

  private

  def with_both_sdks(&block)
    with_sdk_v1_loaded(&block)
    with_sdk_v2_loaded(&block)
  end
end
