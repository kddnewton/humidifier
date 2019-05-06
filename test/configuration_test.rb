# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_ensure_upload_configured!
    error =
      assert_raises RuntimeError do
        build.ensure_upload_configured!(payload(identifier: 'foobar'))
      end
    assert_match(/foobar/, error.message)
  end

  def test_ensure_upload_configured_passes
    config = build(s3_bucket: Object.new)
    config.ensure_upload_configured!(payload(identifier: 'foobar'))
  end

  private

  def build(options = {})
    Humidifier::Configuration.new(options)
  end
end
