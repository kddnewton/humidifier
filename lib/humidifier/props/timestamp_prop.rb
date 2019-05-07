# frozen_string_literal: true

module Humidifier
  module Props
    # A timestamp (ISO 8601) property
    class TimestampProp < Base
      # true if it is whitelisted, a Time, or a Date
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Time) || value.is_a?(Date)
      end
    end
  end
end
