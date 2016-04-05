require 'test_helper'

class RefTest < Minitest::Test

  def test_to_cf
    reference = Object.new
    ref = AwsCF::Ref.new(reference)

    assert_equal ({ 'Ref' => reference }), ref.to_cf
  end
end
