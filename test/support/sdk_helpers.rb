module SdkHelpers

  private

  def payload(opts = {})
    SdkStubber::Payload.new(opts)
  end

  def stub(value)
    SdkStubber::Stub.new(value)
  end

  def unset_shim
    Humidifier::AwsShim.instance_variable_set(:@instance, nil)
  end

  def with_sdk_v1_loaded
    Object.const_set(:AWS, SdkStubber::AwsDouble)
    begin
      unset_shim
      yield Humidifier::AwsShim.shim
    ensure
      Object.send(:remove_const, :AWS)
    end
  end

  def with_sdk_v2_loaded
    Object.const_set(:Aws, SdkStubber::AwsDouble)
    begin
      unset_shim
      yield Humidifier::AwsShim.shim
    ensure
      Object.send(:remove_const, :Aws)
    end
  end
end
