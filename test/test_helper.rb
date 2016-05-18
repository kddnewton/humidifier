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

require 'support/sdk_helpers'
require 'support/sdk_stubber'
Minitest::Test.send(:include, SdkHelpers)

# include the ability to mock the serializer in tests
Minitest::Test.send(:include, Module.new do
  def with_mocked_serializer(value)
    mock = Minitest::Mock.new
    mock.expect(:call, value, [value])

    Humidifier::Serializer.stub(:dump, mock) do
      yield value
    end
    mock.verify
  end
end)

# stub the sleep method so that the tests can run faster
Humidifier::Sleeper.send(:prepend, Module.new do
  def sleep(count)
  end
end)
