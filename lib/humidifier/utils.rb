module Humidifier
  class Utils
    class << self
      def camelize(str)
        str.to_s.capitalize.gsub(/_([a-z])/) { $1.upcase }
      end

      def underscore(str)
        str.gsub(/([A-Z]+)([0-9]|[A-Z]|\z)/) { "#{$1.capitalize}#{$2}" }.gsub(/(.)([A-Z])/, '\1_\2').downcase if str
      end
    end
  end
end
