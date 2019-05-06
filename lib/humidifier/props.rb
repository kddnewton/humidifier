# frozen_string_literal: true

module Humidifier
  # Container for property of CFN resources
  module Props
    class << self
      # builds the appropriate prop object from the given spec line
      def from(key, spec, substructs = {})
        case spec['Type']
        when 'List' then ListProp.new(key, spec, substructs)
        when 'Map'  then MapProp.new(key, spec, substructs)
        else             singular_from(key, spec, substructs)
        end
      end

      # builds a prop that is not a List or Map type
      # PrimitiveType is one of Boolean, Double, Integer, Json, String, or
      # Timestamp
      def singular_from(key, spec, substructs)
        primitive = spec['PrimitiveItemType'] || spec['PrimitiveType']

        if primitive && !%w[List Map].include?(primitive)
          primitive = 'Integer' if primitive == 'Long'
          const_get(:"#{primitive}Prop").new(key, spec)
        else
          StructureProp.new(key, spec, substructs)
        end
      end
    end
  end
end
