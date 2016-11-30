module Humidifier
  module Props
    # A property that is contained in a Map
    class MapProp < Base
      attr_reader :subprop

      # Valid if the value is whitelisted or every value in the map is valid on the subprop
      def valid?(map)
        whitelisted_value?(map) || (map.is_a?(Hash) && map.values.all? { |value| subprop.valid?(value) })
      end

      private

      # Finds the subprop that's specified in the spec
      def after_initialize
        @subprop = Props.singular_from(key, spec)
      end
    end
  end
end
