# frozen_string_literal: true

module Humidifier
  # Reads the specs/CloudFormationResourceSpecification.json file and load each
  # resource as a class
  module Loader
    # Handles searching the PropertyTypes specifications for a specific
    # resource type
    class PropertyTypes
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

    class << self
      # loop through the specs and register each class
      def load
        parsed = parse_spec
        return unless parsed

        types = PropertyTypes.new(parsed['PropertyTypes'])
        parsed['ResourceTypes'].each do |key, spec|
          match = key.match(/\A(\w+)::(\w+)::(\w+)\z/)
          register(match[1], match[2], match[3], spec, types.search(key))
        end

        Humidifier.registry.freeze
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

      def parse_spec
        path = File.expand_path(File.join('..', '..', SPECIFICATION), __dir__)
        return unless File.file?(path)

        JSON.parse(File.read(path))
      end

      def register(top, group, resource, spec, substructs)
        aws_name = "#{top}::#{group}::#{resource}"
        resource_class = build_class(aws_name, spec, substructs)

        unless Humidifier.const_defined?(group)
          Humidifier.const_set(group, Module.new)
        end

        Humidifier.const_get(group).const_set(resource, resource_class)
        Humidifier.registry[aws_name] = resource_class
      end
    end
  end
end
