module Humidifier

  # Builds CFN function calls
  class Fn

    FUNCTIONS = %w[And Base64 Equals FindInMap GetAtt GetAZs If Join Not Or Select].freeze
    attr_accessor :name, :value

    def initialize(name, value)
      self.name = "Fn::#{name}"
      self.value = value
    end

    def to_cf
      { name => value }
    end

    class << self
      FUNCTIONS.each do |function|
        define_method(Utils.underscore(function)) do |value|
          new(function, value)
        end
      end
    end
  end
end
