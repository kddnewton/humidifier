require 'test_helper'

class ConfigurationTest < Minitest::Test

  def test_ensure_upload_configured!
    config = Humidifier::Configuration.new
    error =
      assert_raises RuntimeError do
        config.ensure_upload_configured!(payload(identifier: 'foobar'))
      end
    assert_match(/foobar/, error.message)
  end

  def test_ensure_upload_configured_passes
    config = Humidifier::Configuration.new
    config.s3_bucket = Object.new
    config.ensure_upload_configured!(payload(identifier: 'foobar'))
  end
end
