module AwsCF
  module Props
    class StringProp < Base
      def valid?(value)
        value.is_a?(String)
      end
    end
  end
end
