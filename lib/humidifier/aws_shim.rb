require 'humidifier/aws_adapters/noop'
require 'humidifier/aws_adapters/sdkv1'
require 'humidifier/aws_adapters/sdkv2'

module Humidifier

  # Optionally provides aws-sdk functionality if the gem is loaded
  class AwsShim
    REGION = ENV['AWS_REGION'] || 'us-east-1'

    attr_accessor :shim

    def initialize
      self.shim = begin
        require 'aws-sdk'
        nil
      rescue LoadError
        AwsAdapters::Noop.new
      end
      self.shim ||= AwsAdapters.const_get(Object.const_defined?(:AWS) ? :SDKV1 : :SDKV2).new
    end

    class << self
      extend Forwardable
      def_delegators :shim, :create_stack, :delete_stack, :validate_stack

      def instance
        @instance ||= new
      end

      def shim
        instance.shim
      end
    end
  end
end
