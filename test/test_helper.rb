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

require 'support/test_helpers'
Minitest::Test.send(:include, TestHelpers)
