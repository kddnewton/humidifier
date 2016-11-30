module Humidifier
  module Props
    # An integer property
    class IntegerProp < Base
      # converts the value through #to_i unless it is whitelisted
      def convert(value)
        puts "WARNING: Property #{name} should be an integer" unless valid?(value)
        value.to_i
      end

      # true if it is whitelisted or a Integer
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Integer)
      end
    end
  end
end
