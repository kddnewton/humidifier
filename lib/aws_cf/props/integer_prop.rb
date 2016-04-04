module AwsCF
  module Props
    class IntegerProp < Base
      def valid?(value)
        value.is_a?(Fixnum)
      end
    end
  end
end
