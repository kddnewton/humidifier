module Humidifier

  # Dumps an object to CFN syntax
  class Serializer

    class << self
      def dump(node)
        case node
        when Hash then enumerable_to_h(node) { |(key, value)| [key, dump(value)] }
        when Array then node.map { |value| dump(value) }
        when Ref, Fn then dump(node.to_cf)
        else node
        end
      end

      # back-supporting ruby 2.0's lack of #to_h
      def enumerable_to_h(enumerable)
        enumerable.each_with_object({}) do |item, result|
          key, value = yield item
          result[key] = value
        end
      end
    end
  end
end
