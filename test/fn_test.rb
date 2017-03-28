require 'test_helper'

class FnTest < Minitest::Test
  Humidifier::Fn::FUNCTIONS.each do |name, func|
    define_method(:"test_#{func}") do
      reference = Object.new
      fn = Humidifier::Fn.send(func, reference)
      assert_equal ({ "Fn::#{name}" => reference }), fn.to_cf
    end
  end
end
