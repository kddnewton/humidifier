# frozen_string_literal: true

module Humidifier
  # Represents a CFN stack condition
  class Condition
    attr_reader :opts

    def initialize(opts)
      @opts = opts
    end

    # CFN stack syntax
    def to_cf
      Serializer.dump(opts)
    end
  end
end
