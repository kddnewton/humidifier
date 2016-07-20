module SdkSupport
  def self.double
    AwsDouble
  end

  module ForwardMissing
    def method_missing(method, *args, &block)
      SdkSupport.call(method, args, &block)
    end
  end

  module AwsDouble
    extend ForwardMissing

    module CloudFormation
      module Errors
        class ValidationError < StandardError; end
      end

      class Client
        include ForwardMissing

        def initialize(*)
        end
      end

      class Stack
        include ForwardMissing

        def initialize(*)
        end
      end
    end

    module S3
      extend ForwardMissing

      class Client
        include ForwardMissing

        def initialize(*)
        end
      end

      class Object
        include ForwardMissing

        def initialize(*)
        end
      end
    end
  end
end
