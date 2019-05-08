# frozen_string_literal: true

module Humidifier
  class Config
    class Mapping
      attr_reader :clazz, :mapper

      def initialize(opts = {}, &block)
        @clazz = Humidifier[normalized(opts[:to])]
        raise Error, "Invalid resource: #{opts[:to].inspect}" if @clazz.nil?

        if opts[:using] && block_given?
          raise Error, 'Cannot specify :using and provide an anonymous mapper'
        end

        @mapper = mapper_from(opts, &block)
      end

      def resource_for(name, attributes)
        mapper.resource_for(clazz, name, attributes)
      end

      private

      def mapper_from(opts, &block)
        if opts[:using]
          opts[:using].new
        elsif block_given?
          Class.new(Mapper, &block).new
        else
          Mapper.new
        end
      end

      def normalized(name)
        name.start_with?('AWS') ? name : "AWS::#{name}"
      end
    end
  end
end
