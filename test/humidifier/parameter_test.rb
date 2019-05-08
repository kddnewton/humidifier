# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class ParameterTest < Minitest::Test
    def test_to_cf
      expected = { 'Type' => 'String' }

      assert_equal expected, Parameter.new.to_cf
    end

    def test_to_cf_with_description
      value = 'foobar'

      expected = { 'Type' => 'String', 'Description' => value }
      actual = Parameter.new(description: value).to_cf

      assert_equal expected, actual
    end
  end
end
