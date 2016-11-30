module Humidifier

  # Container for property of CFN resources
  module Props
    class << self
      # builds the appropriate prop object from the given spec line
      def from(key, spec)
        case spec['Type']
        when 'List' then ListProp.new(key, spec)
        when 'Map'  then MapProp.new(key, spec)
        else             singular_from(key, spec)
        end
      end

      # builds a prop that is not a List or Map type
      # PrimitiveType is one of Boolean, Double, Integer, Json, or String
      def singular_from(key, spec)
        if spec.key?('PrimitiveType')
          const_get(:"#{spec['PrimitiveType']}Prop").new(key, spec)
        else
          # TODO: update this when we integrate structures - StructureProp.new(key, spec)
          JsonProp.new(key, spec)
        end
      end
    end
  end
end
