module Humidifier
  module Props
    # A property that is contained in a list
    class ListProp < Base
      attr_reader :subprop

      # CFN stack syntax
      def to_cf(list)
        [key, list.map { |value| subprop.to_cf(value).last }]
      end

      # Valid if the value is whitelisted or every value in the list is valid on the subprop
      def valid?(list)
        whitelisted_value?(list) || (list.is_a?(Enumerable) && list.all? { |value| subprop.valid?(value) })
      end

      private

      # Finds the subprop that's specified in the spec
      def after_initialize(substructs)
        @subprop = Props.singular_from(key, spec, substructs)
      end
    end
  end
end
