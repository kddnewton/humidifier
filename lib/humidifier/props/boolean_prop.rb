module Humidifier
  module Props
    # A boolean property
    class BooleanProp < Base
      # converts through value == 'true'
      def convert(value)
        if %w[true false].include?(value)
          puts "WARNING: Property #{name} should be a boolean, not a string"
          value == 'true'
        else
          value
        end
      end

      # true if it is a boolean
      def valid?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end
  end
end
