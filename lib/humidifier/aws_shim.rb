require 'humidifier/aws_adapters/base'
require 'humidifier/aws_adapters/noop'
require 'humidifier/aws_adapters/sdkv1'
require 'humidifier/aws_adapters/sdkv2'

module Humidifier

  # Optionally provides aws-sdk functionality if the gem is loaded
  class AwsShim

    REGION = ENV['AWS_REGION'] || 'us-east-1'
    STACK_METHODS = {
      create: :create_stack,
      delete: :delete_stack,
      deploy: :deploy_stack,
      exists?: :stack_exists?,
      update: :update_stack,
      valid?: :validate_stack
    }.freeze

    attr_accessor :shim

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
      def_delegators :shim, *STACK_METHODS.values

      def instance
        @instance ||= new
      end

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
