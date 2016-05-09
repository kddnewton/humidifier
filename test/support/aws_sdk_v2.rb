module Aws
  module CloudFormation
    class Client
      def initialize(*)
      end

      def create_template(opts = {})
        raise Errors::ValidationError, 'fake' unless opts[:template_body]
      end

      def validate_template(opts = {})
        raise Errors::ValidationError, 'fake' unless opts[:template_body]
      end
    end

    module Errors
      class ValidationError < StandardError
      end
    end
  end
end
