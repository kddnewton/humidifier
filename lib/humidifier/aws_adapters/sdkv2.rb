module Humidifier
  module AwsAdapters
    class SDKV2 < Base

      def exists?(payload)
        base_module::CloudFormation::Stack.new(name: payload.identifier).exists?
      end

      private

      def base_module
        Aws
      end

      def perform_and_wait(method, payload)
        method = exists?(payload) ? :update : :create if method == :deploy
        response = public_send(method, payload)

        client.wait_until(:"stack_#{method}_complete", stack_name: payload.identifier) do |waiter|
          waiter.max_attempts = MAX_WAIT / 5
          waiter.delay = 5
        end

        response
      end
    end
  end
end
