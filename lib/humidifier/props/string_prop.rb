module Humidifier
  module Props
    # A string property
    class StringProp < Base
      # converts the value through #to_s unless it is whitelisted
      def convert(value)
        puts "WARNING: Property #{name} should be a string" unless valid?(value)
        whitelisted_value?(value) ? value : value.to_s
      end

      # true if it is whitelisted or a String
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(String)
      end
    end
  end
end
