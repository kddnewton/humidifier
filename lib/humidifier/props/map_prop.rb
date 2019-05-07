# frozen_string_literal: true

module Humidifier
  module Props
    # A property that is contained in a Map
    class MapProp < Base
      attr_reader :subprop

      # CFN stack syntax
      def to_cf(map)
        cf_value =
          if map.respond_to?(:to_cf)
            map.to_cf
          else
            map.each_with_object({}) do |(subkey, subvalue), serialized|
              serialized[subkey] = subprop.to_cf(subvalue).last
            end
          end

        [key, cf_value]
      end

      # Valid if the value is whitelisted or every value in the map is valid on
      # the subprop
      def valid?(map)
        return true if whitelisted_value?(map)

        map.is_a?(Hash) && map.values.all? { |value| subprop.valid?(value) }
      end

      private

      # Finds the subprop that's specified in the spec
      def after_initialize(substructs)
        @subprop = Props.singular_from(key, spec, substructs)
      end
    end
  end
end
