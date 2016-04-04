module AwsCF
  module Props
    class ArrayProp < Base

      attr_accessor :sub_prop

      def valid?(value)
        value.is_a?(Array) && value.all? { |sub_value| sub_prop.valid?(sub_value) }
      end

      private

        def after_initialize(args)
          self.sub_prop = Props.from(args[:spec])
        end
    end
  end
end
