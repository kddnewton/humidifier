module Humidifier
  class SdkPayload

    attr_accessor :stack, :options

    extend Forwardable
    def_delegators :stack, :identifier, :name, :to_cf

    def initialize(stack, options)
      self.stack   = stack
      self.options = options
    end
  end
end
