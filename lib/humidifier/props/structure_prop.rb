# frozen_string_literal: true

module Humidifier
  module Props
    # A structure property that references a structure from the specification
    class StructureProp < Base
      attr_reader :subprops

      # CFN stack syntax
      def to_cf(struct)
        cf_value =
          if struct.respond_to?(:to_cf)
            struct.to_cf
          else
            struct.map do |subkey, subvalue|
              subprops[subkey.to_s].to_cf(subvalue)
            end.to_h
          end

        [key, cf_value]
      end

      # true if the value is whitelisted or Hash and all keys are valid for
      # their corresponding props
      def valid?(struct)
        return true if whitelisted_value?(struct)

        struct.is_a?(Hash) && valid_struct?(struct)
      end

      private

      def after_initialize(substructs)
        @subprops = subprops_from(substructs, spec['ItemType'] || spec['Type'])
      end

      def subprops_from(substructs, type)
        subprop_names = substructs.fetch(type, {}).fetch('Properties', {})

        subprop_names.each_with_object({}) do |(key, config), subprops|
          subprop =
            if config['ItemType'] == type
              self
            else
              Props.from(key, config, substructs)
            end

          subprops[Utils.underscore(key)] = subprop
        end
      end

      def valid_struct?(struct)
        struct.all? do |key, value|
          subprops.key?(key.to_s) && subprops[key.to_s].valid?(value)
        end
      end
    end
  end
end
