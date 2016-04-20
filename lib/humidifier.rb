require 'json'
require 'pathname'

require 'humidifier/utils'
require 'humidifier/props'
require 'humidifier/fn'
require 'humidifier/ref'
require 'humidifier/attribute_methods'
require 'humidifier/property_methods'

require 'humidifier/aws_shim'
require 'humidifier/mapping'
require 'humidifier/output'
require 'humidifier/parameter'
require 'humidifier/resource'
require 'humidifier/serializer'
require 'humidifier/stack'
require 'humidifier/version'

# container module for all gem classes
module Humidifier
  class << self
    # convenience method for calling cloudformation functions
    def fn
      Fn
    end

    # convenience method for creating references
    def ref(reference)
      Ref.new(reference)
    end

    # convenience method for finding classes by AWS name
    def [](aws_name)
      Resource.registry[aws_name]
    end
  end
end

# loop through the specs and register each class
Dir[File.expand_path(File.join('..', '..', 'specs', '*'), __FILE__)].each do |filepath|
  group, resource = Pathname.new(filepath).basename('.cf').to_s.split('-')
  spec = File.readlines(filepath).select do |line|
    # flipflop operator (http://stackoverflow.com/questions/14456634)
    true if line.include?('Properties')...(line.strip == '}')
  end
  Humidifier::Resource.register(group, resource, spec[1..-2])
end
