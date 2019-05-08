# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'humidifier'
require 'minitest/autorun'

RESOURCE_NAMES = %w[AlphaUser1 AlphaUser2 AlphaUser3].freeze

class FoobarMapper < Humidifier::Config::Mapper
  defaults do |logical_name|
    { foo: logical_name }
  end

  attribute :bar do |bar|
    { bar: bar }
  end
end

class FoobarResource < Humidifier::Resource
  self.aws_name = 'AWS::Foo::Bar'
  self.props =
    %w[foo bar baz zaz_id].each_with_object({}) do |name, props|
      props[name] = Humidifier::Props::StringProp.new(name)
    end
end

Humidifier.configure do |config|
  config.stack_path = File.expand_path('stacks', __dir__)

  config.stack_prefix = 'reservoir-'

  config.map :users, to: 'AWS::IAM::User'
end
