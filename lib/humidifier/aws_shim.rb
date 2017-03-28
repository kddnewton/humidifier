require 'humidifier/aws_adapters/base'
require 'humidifier/aws_adapters/noop'
require 'humidifier/aws_adapters/sdkv1'
require 'humidifier/aws_adapters/sdkv2'

module Humidifier
  # Optionally provides aws-sdk functionality if the gem is loaded
  class AwsShim
    # The AWS region, can be set through the environment, defaults to us-east-1
    REGION = ENV['AWS_REGION'] || 'us-east-1'

    # Methods that are sent over to the aws adapter from the stack
    STACK_METHODS = %i[
      create delete deploy exists? update upload valid?
      create_and_wait delete_and_wait deploy_and_wait update_and_wait
      create_change_set deploy_change_set
    ].freeze

    attr_accessor :shim

    # Either set the SDK based on the configured option or guess the SDK
    # version by attempting to require both aws-sdk-v1 and aws-sdk, then setting
    # the shim based on what successfully loaded
    def initialize
      self.shim =
        if Humidifier.config.sdk_version_1?
          AwsAdapters::SDKV1.new
        elsif Humidifier.config.sdk_version_2?
          AwsAdapters::SDKV2.new
        else
          guess_sdk
        end
    end

    class << self
      extend Forwardable
      def_delegators :shim, *STACK_METHODS

      # The shim singleton
      def instance
        @instance ||= new
      end

      # The target of all of the forwarding
      def shim
        instance.shim
      end
    end

    private

    def guess_sdk
      try_require_sdk('aws-sdk-v1')
      try_require_sdk('aws-sdk')

      if Object.const_defined?(:Aws)
        AwsAdapters::SDKV2.new
      elsif Object.const_defined?(:AWS)
        AwsAdapters::SDKV1.new
      else
        AwsAdapters::Noop.new
      end
    end

    def try_require_sdk(name)
      require name
    rescue LoadError # rubocop:disable Lint/HandleExceptions
    end
  end
end
