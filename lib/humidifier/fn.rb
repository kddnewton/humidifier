module Humidifier

  # Builds CFN function calls
  class Fn

    # The list of all internal functions provided by AWS from
    # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html
    FUNCTIONS = Utils.underscored(%w[And Base64 Equals FindInMap GetAtt GetAZs If Join Not Or Select])

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
      FUNCTIONS.each do |name, func|
        define_method(func) { |value| new(name, value) }
      end
    end
  end
end
