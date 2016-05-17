module Humidifier
  module AwsAdapters
    class SDKV2 < Base

      def exists?(stack, _ = {})
        base_module::CloudFormation::Stack.new(name: stack.identifier).exists?
      end

      private

      def base_module
        Aws
      end

      def perform_and_wait(method, stack, options = {})
        method = exists?(stack) ? :update : :create if method == :deploy
        response = public_send(method, stack, options)

        client.wait_until(:"stack_#{method}_complete", stack_name: stack.identifier) do |waiter|
          waiter.max_attempts = MAX_WAIT / 5
          waiter.delay        = 5
        end

        response
      end
    end
  end
end
