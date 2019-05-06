# frozen_string_literal: true

require 'test_helper'

class ParameterTest < Minitest::Test
  def test_to_cf
    expected = { 'Type' => 'String' }

    assert_equal expected, Humidifier::Parameter.new.to_cf
  end

  def test_to_cf_with_description
    value = 'foobar'

    expected = { 'Type' => 'String', 'Description' => value }
    actual = Humidifier::Parameter.new(description: value).to_cf

    assert_equal expected, actual
  end
end
