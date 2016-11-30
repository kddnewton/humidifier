module Humidifier
  module Props
    # A structure property that references a structure from the specification
    class StructureProp < Base
      attr_reader :structure

      # Find the specified structure
      def after_initialize
      end

      # true if the structure says the value is valid
      def valid?(value)
      end
    end
  end
end
