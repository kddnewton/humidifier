module Humidifier

  # Container for property of CFN resources
  module Props

    # Superclass for all CFN properties
    class Base
      WHITELIST = [Fn, Ref].freeze

      attr_accessor :key
      attr_reader :value

      def initialize(key = nil)
        self.key = key
      end

      def convertable?
        respond_to?(:convert)
      end

      def name
        @name ||= Utils.underscore(key)
      end

      def to_cf(value)
        [key, Serializer.dump(value)]
      end

      def whitelisted_value?(value)
        WHITELIST.any? { |clazz| value.is_a?(clazz) }
      end
    end

    # An array property
    class ArrayProp < Base
      def valid?(value)
        value.is_a?(Array)
      end
    end

    # A boolean property
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

    # A JSON property (and the default)
    class JSONProp < Base
      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Hash)
      end
    end

    # An integer property
    class IntegerProp < Base
      def convert(value)
        puts "WARNING: Property #{name} should be an integer" unless valid?(value)
        value.to_i
      end

      def valid?(value)
        whitelisted_value?(value) || value.is_a?(Fixnum)
      end
    end

    # A string property
    class StringProp < Base
      def convert(value)
        puts "WARNING: Property #{name} should be a string" unless valid?(value)
        whitelisted_value?(value) ? value : value.to_s
      end

      def valid?(value)
        whitelisted_value?(value) || value.is_a?(String)
      end
    end

    class << self
      def from(spec_line)
        key, type = parse(spec_line)

        case type
        when 'Boolean' then BooleanProp.new(key)
        when 'Integer' then IntegerProp.new(key)
        when 'String' then StringProp.new(key)
        when /\[.*?\]/ then ArrayProp.new(key)
        else JSONProp.new(key)
        end
      end

      def parse(spec_line)
        spec_line.strip!

        if spec_line.include?(':')
          key, type = spec_line.gsub(/,\z/, '').split(': ').map(&:strip)
          [key[1..-2], type]
        else
          [nil, spec_line]
        end
      end
    end
  end
end
