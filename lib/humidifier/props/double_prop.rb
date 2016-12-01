module Humidifier
  module Props
    # A double property
    class DoubleProp < Base
      # converts the value through #to_f unless it is whitelisted
      def convert(value)
        puts "WARNING: Property #{name} should be a double" unless valid?(value)
        value.to_f
      end

      # true if it is whitelisted, an Integer, or a Float
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Integer) || value.is_a?(Float)
      end
    end
  end
end
