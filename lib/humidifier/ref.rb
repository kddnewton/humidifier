# frozen_string_literal: true

module Humidifier
  # Builds CFN references
  class Ref
    attr_reader :reference

    def initialize(reference)
      @reference = reference
    end

    # Builds CFN syntax
    def to_cf
      { 'Ref' => Serializer.dump(reference) }
    end
  end
end
