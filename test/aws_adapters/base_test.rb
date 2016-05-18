require 'test_helper'

class BaseTest < Minitest::Test

  def test_create
    with_both_sdks do |sdk|
      assert sdk.create(payload_double)
      refute sdk.create(payload_double(to_cf: false))
    end
  end

  def test_delete
    with_both_sdks do |sdk|
      assert sdk.delete(payload_double)
    end
  end

  def test_deploy_exists
    with_both_sdks do |sdk|
      mock = Minitest::Mock.new
      mock.expect(:update_stack, true, [stack_name: 'test-stack', template_body: payload_double.to_cf])

      with_stubbed_client(sdk, mock, true) do
        assert sdk.deploy(payload_double)
      end
    end
  end

  def test_deploy_does_not_exist
    with_both_sdks do |sdk|
      response = AwsDouble::Response.new(5)
      mock = Minitest::Mock.new
      mock.expect(:create_stack, response, [stack_name: 'test-stack', template_body: payload_double.to_cf])

      with_stubbed_client(sdk, mock, false) do
        assert sdk.deploy(payload_double)
      end
    end
  end

  def test_update
    with_both_sdks do |sdk|
      assert sdk.update(payload_double)
      refute sdk.update(payload_double(to_cf: false))
    end
  end

  def test_valid?
    with_both_sdks do |sdk|
      assert sdk.valid?(payload_double)
      refute sdk.valid?(payload_double(to_cf: false))
    end
  end

  private

  def with_both_sdks(&block)
    with_sdk_v1_loaded(&block)
    with_sdk_v2_loaded(&block)
  end

  def with_stubbed_client(sdk, mock, stack_exists)
    AwsDouble::CloudFormation.stub(:exists?, stack_exists) do
      sdk.instance_variable_set(:@client, mock)
      yield
      mock.verify
    end
  end
end
