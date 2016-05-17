module AwsDouble
  Response = Struct.new(:stack_id)

  module CloudFormation
    module Errors
      class ValidationError < StandardError; end
    end

    class Client
      def initialize(*)
      end

      def method_missing(_, *, **kwargs)
        raise Errors::ValidationError, 'fake' if kwargs.any? { |_, value| !value }
        Response.new(5)
      end

      def stacks
        CloudFormation.stacks
      end
    end

    class Stack
      def initialize(*)
      end

      def exists?
        CloudFormation.exists?
      end
    end

    class << self
      def exists?
        true
      end

      def stacks
        { 'test-stack' => self }
      end
    end
  end
end
