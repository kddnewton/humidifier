require 'test_helper'

class UtilsTest < Minitest::Test

  def test_enumerable_to_h
    actual = Humidifier::Core::Utils.enumerable_to_h(%w[a b c d]) { |item| [item.to_sym, item.ord] }
    assert_equal ({ a: 97, b: 98, c: 99, d: 100 }), actual
  end

  def test_underscored_empty
    assert_equal ({}), Humidifier::Core::Utils.underscored({})
  end

  def test_underscored
    response = Humidifier::Core::Utils.underscored(%w[TestA TestB])
    assert_equal ({ 'TestA' => :test_a, 'TestB' => :test_b }), response
    assert response.frozen?
  end
end
