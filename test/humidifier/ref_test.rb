# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class RefTest < Minitest::Test
    def test_to_cf
      reference = Object.new
      ref = Ref.new(reference)

      assert_equal ({ 'Ref' => reference }), ref.to_cf
    end

    def test_to_cf_nested_objects
      ref = Humidifier.ref(Humidifier.fn.get_att(%w[Foo Bar]))
      expected = { 'Ref' => { 'Fn::GetAtt' => %w[Foo Bar] } }

      assert_equal expected, ref.to_cf
    end
  end
end
