module Humidifier
  # Represents a CFN stack condition
  class Condition
    attr_accessor :opts

    def initialize(opts)
      self.opts = opts
    end

    # CFN stack syntax
    def to_cf
      Serializer.dump(opts)
    end
  end
end
