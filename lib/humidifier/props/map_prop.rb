module Humidifier
  module Props
    # A property that is contained in a Map
    class MapProp < Base
      attr_reader :subprop

      # CFN stack syntax
      def to_cf(map)
        dumped =
          Utils.enumerable_to_h(map) do |(subkey, subvalue)|
            [subkey, subprop.to_cf(subvalue).last]
          end
        [key, dumped]
      end

      # Valid if the value is whitelisted or every value in the map is valid on the subprop
      def valid?(map)
        whitelisted_value?(map) || (map.is_a?(Hash) && map.values.all? { |value| subprop.valid?(value) })
      end

      private

      # Finds the subprop that's specified in the spec
      def after_initialize(substructs)
        @subprop = Props.singular_from(key, spec, substructs)
      end
    end
  end
end
