module Humidifier
  module Props
    # A structure property that references a structure from the specification
    class StructureProp < Base
      attr_reader :subprops

      # CFN stack syntax
      def to_cf(value)
        dumped =
          Utils.enumerable_to_h(value) do |(subkey, subvalue)|
            subprops[subkey.to_s].to_cf(subvalue)
          end
        [key, dumped]
      end

      # true if the value is whitelisted or Hash and all keys are valid for their corresponding props
      def valid?(struct)
        whitelisted_value?(struct) ||
          (struct.is_a?(Hash) &&
          struct.all? { |key, value| subprops.key?(key.to_s) && subprops[key.to_s].valid?(value) })
      end

      private

      def after_initialize(substructs)
        type = spec['ItemType'] || spec['Type']
        @subprops =
          Utils.enumerable_to_h(substructs[type]['Properties']) do |(key, config)|
            subprop = config['ItemType'] == type ? self : Props.from(key, config, substructs)
            [Utils.underscore(key), subprop]
          end
      end
    end
  end
end
