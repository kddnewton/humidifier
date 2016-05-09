module Humidifier
  module AwsAdapters

    # Doesn't do anything
    class Noop
      def method_missing(method, *)
        if method == :validate_stack
          puts 'WARNING: Not validating because aws-sdk not loaded.'
          false
        else
          super
        end
      end
    end
  end
end
