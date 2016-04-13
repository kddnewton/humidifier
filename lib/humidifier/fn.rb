module Humidifier

  # Builds CFN function calls
  class Fn

    attr_accessor :name, :value

    def initialize(name, value)
      self.name = "Fn::#{name}"
      self.value = value
    end

    def to_cf
      { name => value }
    end

    class << self
      def base64(value)
        new('Base64', value)
      end
    end
  end
end
