require 'test_helper'

class BaseTest < Minitest::Test

  def test_deploy_stack_exists
    mock = Minitest::Mock.new
    mock.expect(:update_stack, true, [stack_name: 'test-stack', template_body: stack_double.to_cf])

    with_sdk_v2_loaded do
      with_stubbed_client(Humidifier::AwsAdapters::SDKV2.new, mock, stack_exists: true) do |adapter|
        assert adapter.deploy_stack(stack_double)
        mock.verify
      end
    end
  end

  def test_deploy_stack_does_not_exist
    mock = Minitest::Mock.new
    mock.expect(:create_stack, true, [stack_name: 'test-stack', template_body: stack_double.to_cf])

    with_sdk_v2_loaded do
      with_stubbed_client(Humidifier::AwsAdapters::SDKV2.new, mock, stack_exists: false) do |adapter|
        assert adapter.deploy_stack(stack_double)
        mock.verify
      end
    end
  end

  private

  def with_stubbed_client(adapter, client, stack_exists: true)
    AwsDouble::CloudFormation.stub(:exists?, stack_exists) do
      adapter.instance_variable_set(:@client, client)
      yield adapter
      client.verify
    end
  end
end
