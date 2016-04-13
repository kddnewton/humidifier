module Humidifier
  module Props
    class Base

      attr_accessor :key
      attr_reader :value

      def initialize(key = nil)
        self.key = key
      end

      def convertable?
        respond_to?(:convert)
      end

      def name
        @name ||= Props.convert(key)
      end

      def to_cf(value)
        [key, process(value)]
      end

      private

        def process(node)
          case node
          when Hash then node.map { |key, value| [key, process(value)] }.to_h
          when Array then node.map { |value| process(value) }
          when Ref, Fn then process(node.to_cf)
          else node
          end
        end
    end

    class ArrayProp < Base
      def valid?(value)
        value.is_a?(Array)
      end
    end

    class BooleanProp < Base
      def convert(value)
        if %w[true false].include?(value)
          puts "WARNING: Property #{name} should be a boolean, not a string"
          value == 'true'
        else
          value
        end
      end

      def valid?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end

    class JSONProp < Base
      def valid?(value)
        value.is_a?(Hash)
      end
    end

    class IntegerProp < Base
      def convert(value)
        puts "WARNING: Property #{name} should be an integer" unless valid?(value)
        value.to_i
      end

      def valid?(value)
        value.is_a?(Fixnum)
      end
    end

    class StringProp < Base
      WHITELIST = [Ref, Fn]

      def convert(value)
        puts "WARNING: Property #{name} should be a string" unless valid?(value)
        WHITELIST.any? { |clazz| value.is_a?(clazz) } ? value : value.to_s
      end

      def valid?(value)
        (WHITELIST + [String]).any? { |clazz| value.is_a?(clazz) }
      end
    end

    class << self
      def convert(key)
        key.gsub(/([A-Z]+)([A-Z]|\z)/) { "#{$1.capitalize}#{$2}" }.gsub(/(.)([A-Z])/, '\1_\2').downcase if key
      end

      def from(spec_line)
        if spec_line.include?(':')
          key, type = spec_line.strip.gsub(/,\z/, '').split(': ').map(&:strip)
          key = key[1..-2]
        else
          key, type = nil, spec_line.strip
        end

        case type
        when 'Boolean' then BooleanProp.new(key)
        when 'Integer' then IntegerProp.new(key)
        when 'String' then StringProp.new(key)
        when /\[.*?\]/ then ArrayProp.new(key)
        else JSONProp.new(key)
        end
      end
    end
  end
end
