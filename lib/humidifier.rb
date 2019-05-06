# frozen_string_literal: true

require 'date'
require 'forwardable'
require 'json'
require 'pathname'
require 'yaml'

require 'humidifier/utils'
require 'humidifier/fn'
require 'humidifier/ref'
require 'humidifier/props'

require 'humidifier/props/base'
require 'humidifier/props/boolean_prop'
require 'humidifier/props/double_prop'
require 'humidifier/props/integer_prop'
require 'humidifier/props/json_prop'
require 'humidifier/props/list_prop'
require 'humidifier/props/map_prop'
require 'humidifier/props/string_prop'
require 'humidifier/props/structure_prop'
require 'humidifier/props/timestamp_prop'

require 'humidifier/condition'
require 'humidifier/config'
require 'humidifier/loader'
require 'humidifier/mapping'
require 'humidifier/output'
require 'humidifier/parameter'
require 'humidifier/resource'
require 'humidifier/sdk_payload'
require 'humidifier/serializer'
require 'humidifier/stack'
require 'humidifier/version'

# container module for all gem classes
module Humidifier
  class << self
    # the configuration instance
    def config
      @config ||= Config.new
    end

    # yield the config object to the block for setting user params
    def configure
      yield config
    end

    # convenience method for calling cloudformation functions
    def fn
      Fn
    end

    # convenience method for creating references
    def ref(reference)
      Ref.new(reference)
    end

    # the list of all registered resources
    def registry
      @registry ||= {}
    end

    # convenience method for finding classes by AWS name
    def [](aws_name)
      registry[aws_name]
    end
  end
end

Humidifier::Loader.load
