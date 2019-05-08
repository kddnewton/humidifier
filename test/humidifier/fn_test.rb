# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class FnTest < Minitest::Test
    Fn::FUNCTIONS.each do |name, func|
      define_method(:"test_#{func}") do
        reference = Object.new
        fn = Fn.public_send(func, reference)

        assert_equal ({ "Fn::#{name}" => reference }), fn.to_cf
      end
    end

    def test_serializes_refs_correctly
      expected = { 'Fn::GetAZs' => { 'Ref' => 'Foobar' } }
      fn = Humidifier.fn.get_azs(Humidifier.ref('Foobar'))

      assert_equal expected, fn.to_cf
    end
  end
end
