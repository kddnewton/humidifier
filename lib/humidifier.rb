# frozen_string_literal: true

require 'date'
require 'json'
require 'pathname'
require 'yaml'

require 'aws-sdk-cloudformation'
require 'aws-sdk-s3'
require 'fast_underscore'

# Hook into the string extension and ensure it works for certain AWS acronyms
String.prepend(
  Module.new do
    def underscore
      FastUnderscore.underscore(gsub(/(ARNs|AZs|VPCs)/) { $1.capitalize })
    end
  end
)

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

    # a frozen hash of the given names mapped to their underscored version
    def underscore(names)
      names.map { |name| [name, name.underscore.to_sym] }.to_h.freeze
    end
  end
end

require 'humidifier/condition'
require 'humidifier/config'
require 'humidifier/fn'
require 'humidifier/loader'
require 'humidifier/mapping'
require 'humidifier/output'
require 'humidifier/parameter'
require 'humidifier/ref'
require 'humidifier/resource'
require 'humidifier/serializer'
require 'humidifier/stack'
require 'humidifier/version'

require 'humidifier/props'

Humidifier::Loader.load
