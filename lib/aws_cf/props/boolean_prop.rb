module AwsCF
  module Props
    class BooleanProp < Base
      def valid?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end
  end
end
