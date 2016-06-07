require 'test_helper'

class SleeperTest < Minitest::Test
  module Ticker
    def self.tick
      @tick ||= 10
      @tick -= 1
      @tick <= 0
    end
  end

  def test_timeout
    assert_raises RuntimeError do
      Humidifier::Core::Sleeper.new(10) { false }
    end
  end

  def test_ticking
    Humidifier::Core::Sleeper.new(10) { Ticker.tick }
    assert Ticker.tick
  end
end
