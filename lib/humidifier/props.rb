# frozen_string_literal: true

module Humidifier
  module Props
    # Superclass for all CFN properties
    class Prop
      # The list of classes that are valid beyond the normal values for each
      # prop
      WHITELIST = [Fn, Ref].freeze

      attr_reader :key, :name, :spec

      def initialize(key, spec = {})
        @key  = key
        @name = key.underscore
        @spec = spec
      end

      # the link to the AWS docs
      def documentation
        spec['Documentation']
      end

      # true if this property is required by the resource
      def required?
        spec['Required']
      end

      # CFN stack syntax
      def to_cf(value)
        [key, Serializer.dump(value)]
      end

      # the type of update that occurs when this property is updated on its
      # associated resource
      def update_type
        spec['UpdateType']
      end

      def valid?(value)
        self.class.allowed_types.any? { |type| value.is_a?(type) }
      end

      class << self
        def allowed_types
          @allowed_types ||= [Fn, Ref]
        end

        def allow_type(*types)
          allowed_types
          @allowed_types += types
        end
      end
    end

    class BooleanProp < Prop
      allow_type TrueClass, FalseClass
    end

    class DoubleProp < Prop
      allow_type Integer, Float
    end

    class IntegerProp < Prop
      allow_type Integer
    end

    class JsonProp < Prop
      allow_type Hash
    end

    class StringProp < Prop
      allow_type String
    end

    class TimestampProp < Prop
      allow_type Time, Date
    end

    class ListProp < Prop
      attr_reader :subprop

      def initialize(key, spec = {}, substructs = {})
        super(key, spec)
        @subprop = Props.singular_from(key, spec, substructs)
      end

      def to_cf(list)
        cf_value =
          if list.respond_to?(:to_cf)
            list.to_cf
          else
            list.map { |value| subprop.to_cf(value).last }
          end

        [key, cf_value]
      end

      def valid?(list)
        return true if super(list)

        list.is_a?(Enumerable) && list.all? { |value| subprop.valid?(value) }
      end
    end

    class MapProp < Prop
      attr_reader :subprop

      def initialize(key, spec = {}, substructs = {})
        super(key, spec)
        @subprop = Props.singular_from(key, spec, substructs)
      end

      def to_cf(map)
        cf_value =
          if map.respond_to?(:to_cf)
            map.to_cf
          else
            map.map do |subkey, subvalue|
              [subkey, subprop.to_cf(subvalue).last]
            end.to_h
          end

        [key, cf_value]
      end

      def valid?(map)
        return true if super(map)

        map.is_a?(Hash) && map.values.all? { |value| subprop.valid?(value) }
      end
    end

    class StructureProp < Prop
      attr_reader :subprops

      def initialize(key, spec = {}, substructs = {})
        super(key, spec)
        @subprops = subprops_from(substructs, spec['ItemType'] || spec['Type'])
      end

      def to_cf(struct)
        cf_value =
          if struct.respond_to?(:to_cf)
            struct.to_cf
          else
            struct.map do |subkey, subvalue|
              subprops[subkey.to_s].to_cf(subvalue)
            end.to_h
          end

        [key, cf_value]
      end

      def valid?(struct)
        super(struct) || (struct.is_a?(Hash) && valid_struct?(struct))
      end

      private

      def subprops_from(substructs, type)
        subprop_names = substructs.fetch(type, {}).fetch('Properties', {})

        subprop_names.each_with_object({}) do |(key, config), subprops|
          subprops[key.underscore] =
            if config['ItemType'] == type
              self
            else
              Props.from(key, config, substructs)
            end
        end
      end

      def valid_struct?(struct)
        struct.all? do |key, value|
          subprops.key?(key.to_s) && subprops[key.to_s].valid?(value)
        end
      end
    end

    class << self
      # builds the appropriate prop object from the given spec line
      def from(key, spec, substructs = {})
        case spec['Type']
        when 'List' then ListProp.new(key, spec, substructs)
        when 'Map'  then MapProp.new(key, spec, substructs)
        else             singular_from(key, spec, substructs)
        end
      end

      # builds a prop that is not a List or Map type
      # PrimitiveType is one of Boolean, Double, Integer, Json, String, or
      # Timestamp
      def singular_from(key, spec, substructs)
        primitive = spec['PrimitiveItemType'] || spec['PrimitiveType']

        if primitive && !%w[List Map].include?(primitive)
          primitive = 'Integer' if primitive == 'Long'
          const_get(:"#{primitive}Prop").new(key, spec)
        else
          StructureProp.new(key, spec, substructs)
        end
      end
    end
  end
end
