module Humidifier
  module AwsAdapters

    # Doesn't do anything
    class Noop
      def method_missing(method, *)
        if AwsShim::STACK_METHODS.include?(method)
          puts "WARNING: Cannot run #{method} because aws-sdk not loaded."
          false
        else
          super
        end
      end
    end
  end
end
