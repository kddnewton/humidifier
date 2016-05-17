module Humidifier
  class SdkPayload

    MAX_WAIT = 180
    attr_accessor :stack, :options, :max_wait

    extend Forwardable
    def_delegators :stack, :id=, :identifier, :name, :to_cf

    def initialize(stack, options)
      self.stack    = stack
      self.options  = options
      self.max_wait = options.delete(:max_wait) || MAX_WAIT
    end

    def ==(other)
      stack == other.stack && options == other.options
    end
  end
end
