require 'test_helper'

class SleeperTest < Minitest::Test
  module Ticker
    def self.tick
      @tick ||= 2
      @tick -= 1
      @tick <= 0
    end
  end

  def test_zero_attempts
    assert_raises RuntimeError do
      Humidifier::Sleeper.new(0) {}
    end
  end

  def test_ticking
    Humidifier::Sleeper.new(5) { Ticker.tick }
    assert Ticker.tick
  end
end
