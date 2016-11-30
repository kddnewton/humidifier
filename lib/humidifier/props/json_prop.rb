module Humidifier
  module Props
    # A Json property
    class JsonProp < Base
      # true if the value is whitelisted, a Hash, or an Array
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Hash) || value.is_a?(Array)
      end
    end
  end
end
