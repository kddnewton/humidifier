require 'test_helper'

class SDKV1Test < Minitest::Test

  def test_create_stack
    with_sdk_v1_loaded do
      assert sdk.create_stack(stack_double)
      refute sdk.create_stack(stack_double(to_cf: false))
    end
  end

  def test_delete_stack
    with_sdk_v1_loaded do
      assert sdk.delete_stack(stack_double)
    end
  end

  def test_stack_exists?
    with_sdk_v1_loaded do
      assert sdk.stack_exists?(stack_double)
      AWS::CloudFormation.stub(:exists?, false) do
        refute sdk.stack_exists?(stack_double)
      end
    end
  end

  def test_update_stack
    with_sdk_v1_loaded do
      assert sdk.update_stack(stack_double)
      refute sdk.update_stack(stack_double(to_cf: false))
    end
  end

  def test_validate_stack
    with_sdk_v1_loaded do
      assert sdk.validate_stack(stack_double)
      refute sdk.validate_stack(stack_double(to_cf: false))
    end
  end

  private

  def sdk
    Humidifier::AwsAdapters::SDKV1.new
  end
end
