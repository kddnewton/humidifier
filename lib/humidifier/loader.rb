module Humidifier
  # Pre-setting this module because AWS has a "Config" module and the below
  # register method dynamically looks up the module to see whether or not it
  # exists, which before ruby 2.2 would result in the warning:
  #   `const_defined?': Use RbConfig instead of obsolete and deprecated Config.
  # @aws AWS::Config
  module Config
  end

  # Reads the specs/CloudFormationResourceSpecification.json file and load each
  # resource as a class
  class Loader
    # The path to the specification file
    filename = 'CloudFormationResourceSpecification.json'
    SPECPATH = File.expand_path(File.join('..', '..', '..', filename), __FILE__)

    # Handles searching the PropertyTypes specifications for a specific
    # resource type
    class StructureContainer
      attr_reader :structs

      def initialize(structs)
        @structs = structs
      end

      # find the substructures necessary for the given resource key
      def search(key)
        results = structs.keys.grep(/#{key}/)
        shortened_names = results.map { |result| result.gsub("#{key}.", '') }
        shortened_names.zip(structs.values_at(*results)).to_h.merge(global)
      end

      private

      def global
        @global ||= structs.reject { |key, _| key.match(/AWS/) }
      end
    end

    # loop through the specs and register each class
    def load
      parsed = JSON.parse(File.read(SPECPATH))
      structs = StructureContainer.new(parsed['PropertyTypes'])

      parsed['ResourceTypes'].each do |key, spec|
        match = key.match(/\AAWS::(\w+)::(\w+)\z/)
        register(match[1], match[2], spec, structs.search(key))
      end
    end

    # convenience class method to build a new loader and call load
    def self.load
      new.load
    end

    private

    def build_class(aws_name, spec, substructs)
      Class.new(Resource) do
        self.aws_name = aws_name
        self.props =
          spec['Properties'].map do |(key, config)|
            prop = Props.from(key, config, substructs)
            [prop.name, prop]
          end.to_h
      end
    end

    def register(group, resource, spec, substructs)
      aws_name = "AWS::#{group}::#{resource}"
      resource_class = build_class(aws_name, spec, substructs)

      unless Humidifier.const_defined?(group)
        Humidifier.const_set(group, Module.new)
      end

      Humidifier.const_get(group).const_set(resource, resource_class)
      Humidifier.registry[aws_name] = resource_class
    end
  end
end
