# frozen_string_literal: true

require "test_helper"

module Humidifier
  class ConfigTest < Minitest::Test
    def test_stack_path=
      config = Config.new

      assert_raises Error do
        config.stack_path = "foobar"
      end
    end
  end
end
