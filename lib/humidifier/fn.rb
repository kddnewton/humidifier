module Humidifier

  # Builds CFN function calls
  class Fn

    # The list of all internal functions provided by AWS from
    # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html
    FUNCTIONS = %w[And Base64 Equals FindInMap GetAtt GetAZs If Join Not Or Select].freeze

    attr_accessor :name, :value

    def initialize(name, value)
      self.name = "Fn::#{name}"
      self.value = value
    end

    # CFN stack syntax
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
