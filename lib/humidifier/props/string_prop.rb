# frozen_string_literal: true

module Humidifier
  module Props
    # A string property
    class StringProp < Base
      # true if it is whitelisted or a String
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(String)
      end
    end
  end
end
