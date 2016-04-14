require 'test_helper'

class FnTest < Minitest::Test

  Humidifier::Fn::FUNCTIONS.each do |function|
    define_method(:"test_#{function}") do
      reference = Object.new
      fn = Humidifier::Fn.send(Humidifier::Props.convert(function), reference)
      assert_equal ({ "Fn::#{function}" => reference }), fn.to_cf
    end
  end
end
