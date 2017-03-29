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

  def test_sdk_version_1?
    assert build(sdk_version: 1).sdk_version_1?
    assert build(sdk_version: '1').sdk_version_1?
    refute build(sdk_version: 'foobar').sdk_version_1?
  end

  def test_sdk_version_2?
    assert build(sdk_version: 2).sdk_version_2?
    assert build(sdk_version: '2').sdk_version_2?
    refute build(sdk_version: 'foobar').sdk_version_2?
  end

  private

  def build(options = {})
    Humidifier::Configuration.new(options)
  end
end
