module Humidifier

  # Builds CFN references
  class Ref

    attr_accessor :reference

    # Stores a reference to another stack resource/property
    def initialize(reference)
      self.reference = reference
    end

    # Builds CFN syntax
    def to_cf
      { 'Ref' => reference }
    end
  end
end
