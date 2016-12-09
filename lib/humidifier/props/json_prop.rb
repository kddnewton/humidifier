module Humidifier
  module Props
    # A Json property
    class JsonProp < Base
      # converts the value through `Hash[value]` unless it is valid
      def convert(value)
        if valid?(value) || !convertable?(value)
          value
        else
          puts "WARNING: Property #{name} should be a Hash"
          Hash[value]
        end
      end

      # true if the value is whitelisted, a Hash, or an Array
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Hash)
      end

      private

      def convertable?(value)
        Hash[value]
      rescue ArgumentError
        false
      end
    end
  end
end
