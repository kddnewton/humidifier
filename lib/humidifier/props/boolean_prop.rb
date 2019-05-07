# frozen_string_literal: true

module Humidifier
  module Props
    # A boolean property
    class BooleanProp < Base
      # true if it is a boolean
      def valid?(value)
        return true if whitelisted_value?(value)

        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end
  end
end
