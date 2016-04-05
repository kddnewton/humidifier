module AwsCF
  module Props
    class JSONProp < Base
      def valid?(value)
        value.is_a?(Hash)
      end
    end
  end
end
