module Humidifier
  module AwsAdapters
    class SDKV1 < Base

      def exists?(stack, _ = {})
        base_module::CloudFormation::Stack.new(stack.identifier).exists?
      end

      def wait(stack, _ = {})
        aws_stack = nil
        Sleeper.new(MAX_WAIT) do
          aws_stack = client.describe_stacks(stack_name: stack.identifier).stacks.first
          !aws_stack.stack_status.end_with?('IN_PROGRESS')
        end

        fail!(stack) if aws_stack.stack_status =~ /(FAILED|ROLLBACK)/
      end

      private

      def base_module
        AWS
      end

      def fail!(stack)
        reasons = []
        client.describe_stack_events(stack_name: stack.identifier).stack_events.each do |event|
          next unless event.resource_status.include?('FAILED') && event.key?(:resource_status_reason)
          reasons.unshift(event.resource_status_reason)
        end
        raise "#{stack.name} stack failed:\n#{reasons.join("\n")}"
      end
    end
  end
end
