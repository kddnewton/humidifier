require 'test_helper'

class FnTest < Minitest::Test

  def test_base64
    reference = Object.new
    fn = Humidifier::Fn.base64(reference)

    assert_equal ({ 'Fn::Base64' => reference }), fn.to_cf
  end
end
