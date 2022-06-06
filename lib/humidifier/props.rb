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

      # def pretty_print(q)
      #   q.text("(#{name}=boolean)")
      # end
    end

    class DoubleProp < Prop
      allow_type Integer, Float

      # def pretty_print(q)
      #   q.text("(#{name}=double)")
      # end
    end

    class IntegerProp < Prop
      allow_type Integer

      # def pretty_print(q)
      #   q.text("(#{name}=integer)")
      # end
    end

    class JsonProp < Prop
      allow_type Hash

      # def pretty_print(q)
      #   q.text("(#{name}=json)")
      # end
    end

    class StringProp < Prop
      allow_type String

      # def pretty_print(q)
      #   q.text("(#{name}=string)")
      # end
    end

    class TimestampProp < Prop
      allow_type Time, Date

      # def pretty_print(q)
      #   q.text("(#{name}=timestamp)")
      # end
    end

    class ListProp < Prop
      attr_reader :subprop

      def initialize(key, spec = {}, subprop = nil)
        super(key, spec)
        @subprop = subprop
      end

      # def pretty_print(q)
      #   q.group do
      #     q.text("(#{name}=list")
      #     q.nest(2) do
      #       q.breakable
      #       q.pp(subprop)
      #     end
      #     q.breakable("")
      #     q.text(")")
      #   end
      # end

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

      def initialize(key, spec = {}, subprop = nil)
        super(key, spec)
        @subprop = subprop
      end

      # def pretty_print(q)
      #   q.group do
      #     q.text("(#{name}=map")
      #     q.nest(2) do
      #       q.breakable
      #       q.pp(subprop)
      #     end
      #     q.breakable("")
      #     q.text(")")
      #   end
      # end

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

      def initialize(key, spec = {}, subprops = {})
        super(key, spec)
        @subprops = subprops
      end

      # def pretty_print(q)
      #   q.group do
      #     q.text("(#{name}=structure")
      #     q.nest(2) do
      #       q.breakable
      #       q.seplist(subprops.values) { |subprop| q.pp(subprop) }
      #     end
      #     q.breakable("")
      #     q.text(")")
      #   end
      # end

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

      def valid_struct?(struct)
        struct.all? do |key, value|
          subprops.key?(key.to_s) && subprops[key.to_s].valid?(value)
        end
      end
    end
  end
end
