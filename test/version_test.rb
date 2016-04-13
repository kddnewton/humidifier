require 'test_helper'

class VersionTest < Minitest::Test
  def test_version
    refute_nil ::Humidifier::VERSION
  end
end
