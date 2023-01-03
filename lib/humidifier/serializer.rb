# frozen_string_literal: true

module Humidifier
  # Dumps an object to CFN syntax
  class Serializer
    class << self
      # dumps the given object out to CFN syntax recursively
      def dump(node)
        case node
        when Hash
          node.to_h { |key, value| [key, dump(value)] }
        when Array
          node.map { |value| dump(value) }
        when Ref, Fn
          dump(node.to_cf)
        when Date
          node.iso8601
        when Time
          node.to_datetime.iso8601
        else
          node
        end
      end
    end
  end
end
