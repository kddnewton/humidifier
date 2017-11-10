module Humidifier
  # Builds CFN function calls
  class Fn
    # The list of all internal functions provided by AWS from
    # http://docs.aws.amazon.com
    #   /AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html
    FUNCTIONS = Utils.underscored(%w[And Base64 Equals FindInMap GetAtt GetAZs
                                     If ImportValue Join Not Or Select Sub])

    attr_reader :name, :value

    def initialize(name, value)
      @name = "Fn::#{name}"
      @value = value
    end

    # CFN stack syntax
    def to_cf
      { name => Serializer.dump(value) }
    end

    class << self
      FUNCTIONS.each do |name, func|
        define_method(func) { |value| new(name, value) }
      end
    end
  end
end
