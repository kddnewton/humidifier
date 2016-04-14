module Humidifier

  # Optionally provides aws-sdk functionality if the gem is loaded
  class AWSShim
    REGION = ENV['AWS_REGION'] || 'us-east-1'

    # Doesn't do anything
    class Noop
      def method_missing(method, *)
        if method == :validate_stack
          puts 'WARNING: Not validating because aws-sdk not loaded.'
          false
        else
          super
        end
      end
    end

    # Validate using v1 of the aws-sdk
    class SDKV1
      def validate_stack(stack)
        AWS::CloudFormation::Client.new(region: REGION).validate_template(template_body: stack.to_cf)
        true
      rescue AWS::CloudFormation::Errors::ValidationError
        false
      end
    end

    # Validate using v2 of the aws-sdk
    class SDKV2
      def validate_stack(stack)
        Aws::CloudFormation::Client.new(region: REGION).validate_template(template_body: stack.to_cf)
        true
      rescue Aws::CloudFormation::Errors::ValidationError
        false
      end
    end

    attr_accessor :shim

    def initialize
      self.shim = begin
        require 'aws-sdk'
        nil
      rescue LoadError
        Noop.new
      end
      self.shim ||= Object.const_defined?(:AWS) ? SDKV1.new : SDKV2.new
    end

    class << self
      def instance
        @instance ||= new
      end

      def validate_stack(stack)
        instance.shim.validate_stack(stack)
      end
    end
  end
end
