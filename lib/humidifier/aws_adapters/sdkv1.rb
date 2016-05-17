module Humidifier
  module AwsAdapters
    class SDKV1 < Base

      def exists?(payload)
        base_module::CloudFormation::Stack.new(payload.identifier).exists?
      end

      private

      def base_module
        AWS
      end

      def handle_failure(payload)
        reasons = []
        client.describe_stack_events(stack_name: payload.identifier).stack_events.each do |event|
          next unless event.resource_status.include?('FAILED') && event.key?(:resource_status_reason)
          reasons.unshift(event.resource_status_reason)
        end
        raise "#{payload.name} stack failed:\n#{reasons.join("\n")}"
      end

      def perform_and_wait(method, payload)
        response = public_send(method, payload)

        aws_stack = nil
        Sleeper.new(payload.max_wait) do
          aws_stack = client.describe_stacks(stack_name: payload.identifier).stacks.first
          !aws_stack.stack_status.end_with?('IN_PROGRESS')
        end

        handle_failure(payload) if aws_stack.stack_status =~ /(FAILED|ROLLBACK)/
        response
      end
    end
  end
end
