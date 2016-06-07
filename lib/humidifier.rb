require 'forwardable'
require 'json'
require 'pathname'

require 'humidifier/humidifier'
require 'humidifier/core/utils'

require 'humidifier/core/fn'
require 'humidifier/core/ref'
require 'humidifier/core/props'

require 'humidifier/core/aws_shim'
require 'humidifier/core/loader'
require 'humidifier/core/mapping'
require 'humidifier/core/output'
require 'humidifier/core/parameter'
require 'humidifier/core/resource'
require 'humidifier/core/sdk_payload'
require 'humidifier/core/serializer'
require 'humidifier/core/sleeper'
require 'humidifier/core/stack'
require 'humidifier/version'

# container module for all gem classes
module Humidifier
  class << self
    # convenience method for calling cloudformation functions
    def fn
      Core::Fn
    end

    # convenience method for creating references
    def ref(reference)
      Core::Ref.new(reference)
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

  # the container for all non-dynamically generated constants
  module Core
  end
end

Humidifier::Core::Loader.load
