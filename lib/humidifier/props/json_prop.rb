# frozen_string_literal: true

module Humidifier
  module Props
    # A Json property
    class JsonProp < Base
      # true if the value is whitelisted, a Hash, or an Array
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Hash)
      end
    end
  end
end
