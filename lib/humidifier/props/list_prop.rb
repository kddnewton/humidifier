module Humidifier
  module Props
    # A property that is contained in a list
    class ListProp < Base
      attr_reader :subprop

      # Valid if the value is whitelisted or every value in the list is valid on the subprop
      def valid?(list)
        whitelisted_value?(list) || (list.is_a?(Enumerable) && list.all? { |value| subprop.valid?(value) })
      end

      private

      # Finds the subprop that's specified in the spec
      def after_initialize
        @subprop = Props.singular_from(key, spec)
      end
    end
  end
end
