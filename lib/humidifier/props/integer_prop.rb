module Humidifier
  module Props
    # An integer property
    class IntegerProp < Base
      # converts the value through #to_i unless it is valid
      def convert(value)
        if valid?(value) || !value.respond_to?(:to_i)
          value
        else
          puts "WARNING: Property #{name} should be an integer"
          value.to_i
        end
      end

      # true if it is whitelisted or a Integer
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Integer)
      end
    end
  end
end
