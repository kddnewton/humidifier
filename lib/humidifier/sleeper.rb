module Humidifier
  # Manages waiting for stack events for v1 of the SDK
  class Sleeper
    attr_accessor :attempts

    # Store attempts and wait for the block to return true
    def initialize(attempts, &block)
      self.attempts = attempts
      hibernate_until(&block)
    end

    private

    def hibernate_until(&block)
      raise 'Waited too long, giving up' if attempts.zero?
      return if yield

      self.attempts -= 1
      sleep 1
      hibernate_until(&block)
    end
  end
end
