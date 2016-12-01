module Humidifier
  module Props
    # A timestamp (ISO 8601) property
    class TimestampProp < Base
      # converts the value through #to_s unless it is whitelisted
      def convert(value)
        puts "WARNING: Property #{name} should be a Date or Time" unless valid?(value)
        valid?(value) ? value : DateTime.parse(value)
      end

      # true if it is whitelisted, a Time, or a Date
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Time) || value.is_a?(Date)
      end
    end
  end
end
