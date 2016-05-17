require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'humidifier'

require 'fileutils'
require 'minitest/autorun'

require 'support/aws_double'
require 'support/sdk_helpers'
require 'support/test_helpers'

Minitest::Test.send(:include, SdkHelpers)
Minitest::Test.send(:include, TestHelpers)

# stub the sleep method so that the tests can run faster
Humidifier::Sleeper.prepend(Module.new do
  def sleep(count)
  end
end)
