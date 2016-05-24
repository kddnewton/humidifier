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
      create delete deploy exists? update valid?
      create_and_wait delete_and_wait deploy_and_wait update_and_wait
    ].freeze

    attr_accessor :shim

    # Attempt to require both aws-sdk-v1 and aws-sdk, then set the shim based on what successfully loaded
    def initialize
      try_require_sdk('aws-sdk-v1')
      try_require_sdk('aws-sdk')

      self.shim =
        if Object.const_defined?(:AWS)
          AwsAdapters::SDKV1.new
        elsif Object.const_defined?(:Aws)
          AwsAdapters::SDKV2.new
        else
          AwsAdapters::Noop.new
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

    def try_require_sdk(name)
      require name
    rescue LoadError # rubocop:disable Lint/HandleExceptions
    end
  end
end
