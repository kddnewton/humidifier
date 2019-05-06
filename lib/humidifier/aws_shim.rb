# frozen_string_literal: true

require 'humidifier/aws_adapters/base'
require 'humidifier/aws_adapters/sdkv2'
require 'humidifier/aws_adapters/sdkv3'

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

    attr_reader :shim

    # Either set the SDK based on the configured option or guess the SDK
    # version by attempting to require both aws-sdk-v1 and aws-sdk, then setting
    # the shim based on what successfully loaded
    def initialize
      @shim = AwsAdapters::SDKV3.new
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
  end
end
