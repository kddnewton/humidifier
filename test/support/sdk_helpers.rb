module SdkHelpers
  class << self
    attr_accessor :stderr
  end

  private

  def load_sdk_v1
    Object.const_set(:AWS, AwsDouble)
    hide_stderr
  end

  def load_sdk_v2
    Object.const_set(:Aws, AwsDouble)
    hide_stderr
  end

  def hide_stderr
    SdkHelpers.stderr = $stderr.dup
    $stderr.reopen('/dev/null', 'w')
  end

  def show_stderr
    $stderr.reopen(SdkHelpers.stderr)
    SdkHelpers.stderr = nil
  end

  def unload_sdk_v1
    Object.send(:remove_const, :AWS)
    show_stderr
  end

  def unload_sdk_v2
    Object.send(:remove_const, :Aws)
    show_stderr
  end

  def with_sdk_v1_loaded
    load_sdk_v1
    begin
      yield
    ensure
      unload_sdk_v1
    end
  end

  def with_sdk_v2_loaded
    load_sdk_v2
    begin
      yield
    ensure
      unload_sdk_v2
    end
  end
end
