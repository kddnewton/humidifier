# frozen_string_literal: true

module Humidifier
  module Props
    # A timestamp (ISO 8601) property
    class TimestampProp < Base
      # converts the value through DateTime.parse(value) unless it is valid
      def convert(value)
        if valid?(value) || !value.is_a?(String)
          value
        else
          puts "WARNING: Property #{name} should be a Date or Time"
          DateTime.parse(value) # rubocop:disable Style/DateTime
        end
      end

      # true if it is whitelisted, a Time, or a Date
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Time) || value.is_a?(Date)
      end
    end
  end
end
