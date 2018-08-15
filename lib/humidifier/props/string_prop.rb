# frozen_string_literal: true

module Humidifier
  module Props
    # A string property
    class StringProp < Base
      # converts the value through #to_s unless it is valid
      def convert(value)
        if valid?(value)
          value
        else
          puts "WARNING: Property #{name} should be a string"
          value.to_s
        end
      end

      # true if it is whitelisted or a String
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(String)
      end
    end
  end
end
