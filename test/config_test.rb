# frozen_string_literal: true

require 'test_helper'

class ConfigTest < Minitest::Test
  def test_ensure_upload_configured!
    error =
      assert_raises RuntimeError do
        Humidifier::Config.new.ensure_upload_configured!('foobar')
      end

    assert_match(/foobar/, error.message)
  end

  def test_ensure_upload_configured_passes
    config = Humidifier::Config.new(s3_bucket: Object.new)
    config.ensure_upload_configured!('foobar')
  end
end
