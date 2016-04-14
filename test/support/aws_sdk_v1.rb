module AWS
  module CloudFormation
    class Client
      def initialize(*)
      end

      def validate_template(template_body:)
        raise Errors::ValidationError, 'fake' unless template_body
      end
    end

    module Errors
      class ValidationError < StandardError
      end
    end
  end
end
