module AwsCF
  module Props
    def self.from(spec_line)
      if spec_line.include?(':')
        key, type = spec_line.strip.gsub(/,\z/, '').split(' : ')
        key = key[1..-2]
      else
        key, type = nil, spec_line.strip
      end

      case type
      when 'Boolean' then BooleanProp.new(key: key)
      when 'Integer' then IntegerProp.new(key: key)
      when 'String' then StringProp.new(key: key)
      when /\[ (.*?),.*?\]/ then ArrayProp.new(key: key, spec: $1)
      else JSONProp.new(key: key)
      end
    end
  end
end

require 'aws_cf/props/base'
require 'aws_cf/props/array_prop'
require 'aws_cf/props/boolean_prop'
require 'aws_cf/props/json_prop'
require 'aws_cf/props/integer_prop'
require 'aws_cf/props/string_prop'
