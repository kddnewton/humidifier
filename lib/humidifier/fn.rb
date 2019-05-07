# frozen_string_literal: true

module Humidifier
  class Fn
    # The list of all internal functions provided by AWS from
    # http://docs.aws.amazon.com
    #   /AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html
    FUNCTIONS =
      Humidifier.underscore(
        %w[And Base64 Cidr Equals FindInMap GetAtt GetAZs If ImportValue Join
           Not Or Select Split Sub Transform]
      )

    attr_reader :name, :value

    def initialize(name, value)
      @name = "Fn::#{name}"
      @value = value
    end

    def to_cf
      { name => Serializer.dump(value) }
    end

    FUNCTIONS.each do |name, func|
      define_singleton_method(func) { |value| new(name, value) }
    end
  end
end
