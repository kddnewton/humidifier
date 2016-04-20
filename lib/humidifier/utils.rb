module Humidifier
  class Utils
    class << self
      def camelize(str)
        str.to_s.capitalize.gsub(/_([a-z])/) { $1.upcase }
      end
    end
  end
end
