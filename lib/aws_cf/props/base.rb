module AwsCF
  module Props
    class Base

      attr_accessor :key
      attr_reader :value

      def initialize(args = {})
        self.key = args[:key]
        after_initialize(args)
      end

      def name
        @name ||= key && key.gsub(/(.)([A-Z])/, '\1_\2').downcase
      end

      def to_cf(value)
        [key, value]
      end

      private

        def after_initialize(args)
        end
    end
  end
end
