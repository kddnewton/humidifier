module SdkSupport
  module AwsDouble
    module CloudFormation
      module Errors
        class ValidationError < StandardError; end
      end

      class Client
        def initialize(*)
        end

        def method_missing(method, *args, &block)
          SdkSupport.call(method, args, &block)
        end
      end

      class Stack
        def initialize(*)
        end

        def method_missing(method, *args, &block)
          SdkSupport.call(method, args, &block)
        end
      end
    end
  end
end
