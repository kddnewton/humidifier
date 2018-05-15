module SdkSupport
  def self.double
    AwsDouble
  end

  module ForwardMissing
    # rubocop:disable Style/MethodMissingSuper
    def method_missing(method, *args, &block)
      SdkSupport.call(method, args, &block)
    end
    # rubocop:enable Style/MethodMissingSuper

    def respond_to_missing?(_method)
      true
    end
  end

  module AwsDouble
    CORE_GEM_VERSION = '2.0.0'.freeze
    extend ForwardMissing

    module CloudFormation
      module Errors
        class ValidationError < StandardError; end
      end

      class Client
        include ForwardMissing

        def initialize(*); end
      end

      class Stack
        include ForwardMissing

        def initialize(*); end
      end
    end

    module S3
      extend ForwardMissing

      class Client
        include ForwardMissing

        def initialize(*); end
      end

      class Object
        include ForwardMissing

        def initialize(*); end
      end
    end
  end
end
