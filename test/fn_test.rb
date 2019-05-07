# frozen_string_literal: true

require 'test_helper'

class FnTest < Minitest::Test
  Humidifier::Fn::FUNCTIONS.each do |name, func|
    define_method(:"test_#{func}") do
      reference = Object.new
      fn = Humidifier::Fn.public_send(func, reference)

      assert_equal ({ "Fn::#{name}" => reference }), fn.to_cf
    end
  end

  def test_serializes_refs_correctly
    expected = { 'Fn::GetAZs' => { 'Ref' => 'Foobar' } }

    assert_equal expected, Humidifier.fn.get_azs(Humidifier.ref('Foobar')).to_cf
  end
end
