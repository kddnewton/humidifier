require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @stack = Humidifier::Stack.new(name: 'test-stack')
  end

  def test_deploy_stack_exists
    mock = Minitest::Mock.new
    mock.expect(:update_stack, true, [stack_name: 'test-stack', template_body: @stack.to_cf])

    with_stubbed_sdk(mock, stack_exists: true) do
      assert @stack.deploy
      mock.verify
    end
  end

  def test_deploy_stack_does_not_exist
    mock = Minitest::Mock.new
    mock.expect(:create_stack, true, [stack_name: 'test-stack', template_body: @stack.to_cf])

    with_stubbed_sdk(mock, stack_exists: false) do
      assert @stack.deploy
      mock.verify
    end
  end

  private

  def with_stubbed_client(client)
    Humidifier::AwsShim.instance_variable_set(:@instance, nil)
    old_client = Humidifier::AwsShim.shim.send(:client)
    begin
      Humidifier::AwsShim.shim.instance_variable_set(:@client, client)
      yield
    ensure
      Humidifier::AwsShim.shim.instance_variable_set(:@client, old_client)
    end
  end

  def with_stubbed_sdk(client, stack_exists: true, &block)
    with_faked_sdk_require do
      with_sdk_v2_loaded do
        AwsDouble::CloudFormation.stub(:exists?, stack_exists) do
          with_stubbed_client(client, &block)
        end
      end
    end
  end
end
