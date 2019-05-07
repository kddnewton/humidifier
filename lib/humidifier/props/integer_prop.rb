# frozen_string_literal: true

module Humidifier
  module Props
    # An integer property
    class IntegerProp < Base
      # true if it is whitelisted or a Integer
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Integer)
      end
    end
  end
end
