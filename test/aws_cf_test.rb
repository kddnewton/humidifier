require 'test_helper'

class AwsCFTest < Minitest::Test

  def test_fn
    assert_equal AwsCF::Fn, AwsCF.fn
  end

  def test_ref
    reference = Object.new
    assert_kind_of AwsCF::Ref, AwsCF.ref(reference)
    assert_equal reference, AwsCF.ref(reference).reference
  end
end
