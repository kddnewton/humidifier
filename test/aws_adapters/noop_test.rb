require 'test_helper'

class NoopTest < Minitest::Test

  def test_method_missing
    noop = Humidifier::AwsAdapters::Noop.new
    out, * = capture_io do
      refute noop.validate_stack
    end
    assert_match(/WARNING/, out)
  end

  def test_invalid
    noop = Humidifier::AwsAdapters::Noop.new
    assert_raises NoMethodError do
      noop.validate
    end
  end
end
