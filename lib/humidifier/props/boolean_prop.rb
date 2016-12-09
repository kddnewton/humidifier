module Humidifier
  module Props
    # A boolean property
    class BooleanProp < Base
      # converts the value through `value == 'true'` unless it is valid
      def convert(value)
        if valid?(value) || !%w[true false].include?(value)
          value
        else
          puts "WARNING: Property #{name} should be a boolean, not a string"
          value == 'true'
        end
      end

      # true if it is a boolean
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end
  end
end
