# frozen_string_literal: true

module Humidifier
  module AwsAdapters
    # An adapter used when neither SDK is loaded
    class Noop
      # Capture all STACK_METHODS method calls and warn that they will not be
      # run
      def method_missing(method, *)
        if AwsShim::STACK_METHODS.include?(method)
          puts "WARNING: Cannot run #{method} because aws-sdk not loaded."
          false
        else
          super
        end
      end

      # We capture stack methods and warn about them but don't actually respond
      # to them
      def respond_to_missing?(method, *)
        AwsShim::STACK_METHODS.include?(method) ? false : super
      end
    end
  end
end
