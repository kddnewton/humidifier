module SdkSupport
  module Helpers
    class PayloadStack
      attr_accessor :id, :identifier, :name, :to_cf

      def initialize(opts = {})
        opts.each { |key, value| instance_variable_set(:"@#{key}", value) }
      end
    end

    private

    def payload(opts = {})
      Humidifier::SdkPayload.new(PayloadStack.new(opts), {})
    end

    def stub(value)
      Stub.new(value)
    end

    def unset_shim
      Humidifier::AwsShim.instance_variable_set(:@instance, nil)
    end

    def with_sdk_v1_loaded
      Object.const_set(:AWS, AwsDouble)
      begin
        unset_shim
        yield Humidifier::AwsShim.shim
      ensure
        Object.send(:remove_const, :AWS)
      end
    end

    def with_sdk_v2_loaded
      Object.const_set(:Aws, AwsDouble)
      begin
        unset_shim
        yield Humidifier::AwsShim.shim
      ensure
        Object.send(:remove_const, :Aws)
      end
    end

    def with_sdk_v3_loaded
      with_core_gem_version do
        begin
          Object.const_set(:Aws, AwsDouble)
          unset_shim
          yield Humidifier::AwsShim.shim
        ensure
          Object.send(:remove_const, :Aws)
        end
      end
    end

    def with_core_gem_version
      previous_gem_version = AwsDouble::CORE_GEM_VERSION
      AwsDouble.send(:remove_const, :CORE_GEM_VERSION)
      AwsDouble.const_set(:CORE_GEM_VERSION, '3.0.0')
      yield
    ensure
      AwsDouble.send(:remove_const, :CORE_GEM_VERSION)
      AwsDouble.const_set(:CORE_GEM_VERSION, previous_gem_version)
    end
  end
end
