module Humidifier
  module Props
    # A Json property
    class JsonProp < Base
      # converts the value through #to_h unless it is valid
      def convert(value)
        if valid?(value) || !value.respond_to?(:to_h)
          value
        else
          puts "WARNING: Property #{name} should be a Hash or an Array"
          value.to_h
        end
      end

      # true if the value is whitelisted, a Hash, or an Array
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Hash) || value.is_a?(Array)
      end
    end
  end
end
