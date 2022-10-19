# frozen_string_literal: true

module Humidifier
  # Reads the specs/CloudFormationResourceSpecification.json file and load each
  # resource as a class
  module Loader
    class Compiler
      attr_reader :specification, :property_types

      def initialize(specification)
        @specification = specification

        # Set an initial value for each property types so that we can handle
        # cycles in the specification
        @property_types = specification["PropertyTypes"].to_h do |name, _|
          [name, {}]
        end
      end

      def compile
        # Loop through every property type that's already defined and build up
        # each of the properties into the list
        property_types.each do |property_type_name, property_type|
          prefix = property_type_name.split(".", 2).first

          subspec = specification["PropertyTypes"].fetch(property_type_name)
          subspec.fetch("Properties") { {} }.each do |property_name, property|
            property = build_property(prefix, property_name, property)
            property_type[property.name] = property if property
          end
        end

        # Loop through every resource type in the specification and define a
        # class for each one dynamically.
        specification["ResourceTypes"].each do |aws_name, resource_type|
          _top, group, resource = aws_name.split("::")

          properties = {}
          resource_type["Properties"].each do |property_name, property|
            property = build_property(aws_name, property_name, property)
            properties[property.name] = property if property
          end

          resource_class =
            Class.new(Resource) do
              self.aws_name = aws_name
              self.props = properties
            end

          group_module =
            if Humidifier.const_defined?(group)
              Humidifier.const_get(group)
            else
              Humidifier.const_set(group, Module.new)
            end

          Humidifier.registry[aws_name] =
            group_module.const_set(resource, resource_class)
        end

        Humidifier.registry.freeze
      end

      private

      def build_primitive(type, name, spec)
        case type
        in "Boolean"
          Props::BooleanProp.new(name, spec)
        in "Double"
          Props::DoubleProp.new(name, spec)
        in "Integer" | "Long"
          Props::IntegerProp.new(name, spec)
        in "Json"
          Props::JsonProp.new(name, spec)
        in "String"
          Props::StringProp.new(name, spec)
        in "Timestamp"
          Props::TimestampProp.new(name, spec)
        end
      end

      def build_property(prefix, name, spec)
        case spec.transform_keys(&:to_sym)
        in { PrimitiveType: type }
          build_primitive(type, name, spec)
        in { Type: "List", PrimitiveItemType: type }
          Props::ListProp.new(name, spec, build_primitive(type, name, spec))
        in { Type: "Map", PrimitiveItemType: type }
          Props::MapProp.new(name, spec, build_primitive(type, name, spec))
        in { Type: "List", ItemType: "List" }
          # specifically calling this out since
          # AWS::Rekognition::StreamProcessor.PolygonRegionsOfInterest has a
          # nested list structure that otherwise breaks the compiler
          Props::ListProp.new(name, spec, Props::ListProp.new(name, spec))
        in { Type: "List", ItemType: item_type }
          Props::ListProp.new(
            name,
            spec,
            Props::StructureProp.new(name, spec,
                                     property_type(prefix, item_type))
          )
        in { Type: "Map", ItemType: item_type }
          Props::MapProp.new(
            name,
            spec,
            Props::StructureProp.new(name, spec,
                                     property_type(prefix, item_type))
          )
        in { Type: type }
          Props::StructureProp.new(name, spec, property_type(prefix, type))
        else
          # It's possible to hit this clause if the specification has a property
          # that is not currently supported by CloudFormation. In this case,
          # we're not going to create a property at all for it.
        end
      end

      def property_type(prefix, type)
        property_types.fetch("#{prefix}.#{type}") do
          property_types.fetch(type)
        end
      end
    end

    # loop through the specs and register each class
    def self.load
      filepath = File.expand_path("../../#{SPECIFICATION}", __dir__)
      return unless File.file?(filepath)

      Compiler.new(JSON.parse(File.read(filepath))).compile
    end
  end
end
