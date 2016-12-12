module Humidifier
  module Props
    # Superclass for all CFN properties
    class Base

      # The list of classes that are valid beyond the normal values for each prop
      WHITELIST = [Fn, Ref].freeze

      attr_reader :key, :name, :spec, :substructs

      def initialize(key, spec = {}, substructs = {})
        @key  = key
        @name = Utils.underscore(key)
        @spec = spec
        after_initialize(substructs) if respond_to?(:after_initialize, true)
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

      # the type of update that occurs when this property is updated on its associated resource
      def update_type
        spec['UpdateType']
      end

      # true if the given value is of a type contained in the whitelist
      def whitelisted_value?(value)
        WHITELIST.any? { |clazz| value.is_a?(clazz) }
      end
    end
  end
end
