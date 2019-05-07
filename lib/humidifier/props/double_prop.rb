# frozen_string_literal: true

module Humidifier
  module Props
    # A double property
    class DoubleProp < Base
      # true if it is whitelisted, an Integer, or a Float
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Integer) || value.is_a?(Float)
      end
    end
  end
end
