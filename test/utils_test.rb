require 'test_helper'

class UtilsTest < Minitest::Test

  def test_underscored_empty
    assert_equal ({}), Humidifier::Utils.underscored({})
  end

  def test_underscored
    response = Humidifier::Utils.underscored(%w[TestA TestB])
    assert_equal ({ 'TestA' => :test_a, 'TestB' => :test_b }), response
    assert response.frozen?
  end
end
