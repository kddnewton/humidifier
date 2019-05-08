# frozen_string_literal: true

module Humidifier
  class Config
    # The parent class for mapper classes. These classes are used to transform
    # arbitrary attributes coming from the user-provided YAML files into valid
    # CloudFormation props that can then be used in the template. This class
    # provides an easy-to-extend DSL that allows for default attributes
    # specifying custom attributes.
    class Mapper
      # Raised when the attribute given in the file could not be matched to an
      # attribute in the mapper.
      class InvalidResourceAttributeError < Error
        def initialize(clazz, key)
          super("Invalid attribute name given for #{clazz.aws_name}: #{key}")
        end
      end

      # The list of attributes that are common to all resources that need to be
      # handled separately.
      COMMON_ATTRIBUTES = Resource::COMMON_ATTRIBUTES.values

      class << self
        # Defines a custom attribute. The given block will receive the
        # user-provided value for the attribute. The block should return a hash
        # where the keys are valid humidifier properties and the values are
        # valid values for those properties. In the below example, we specify
        # the group attribute which maps to the groups attribute after some
        # transformation.
        #
        #     attribute :group do |group|
        #       groups = GROUPS[group]
        #       groups.any? ? { groups: GROUPS[group] } : {}
        #     end
        def attribute(name, &block)
          define_method(:"attribute_#{name}", &block)
          attribute_methods << name
        end

        # The names of the custom attribute methods.
        def attribute_methods
          @attribute_methods ||= []
        end

        # Defines the default attributes that should be applied to all resources
        # of this type. The given block will be passed the logical resource
        # name that the user specified for the resource. The block should return
        # a hash where the keys are valid humidifier properties and the values
        # are valid values for those properties. In the example below, the
        # user_name property is set based on the logical name.
        #
        #     defaults do |name|
        #       { user_name: name }
        #     end
        def defaults(&block)
          define_method(:attribute_defaults, &block)
        end
      end

      # Builds a humidifier resource using the given humidifier resource class,
      # the logical name for the resource, and the user-specified attributes.
      def resource_for(clazz, name, attributes)
        mapped =
          respond_to?(:attribute_defaults) ? attribute_defaults(name) : {}

        attributes.each do |key, value|
          mapped.merge!(mapped_from(clazz, key, value))
        end

        common_attributes = common_attributes_from(mapped)

        resource = clazz.new(mapped)
        resource.update_attributes(common_attributes)
        resource
      end

      private

      def common_attributes_from(mapped)
        COMMON_ATTRIBUTES.each_with_object({}) do |common_attribute, extract|
          extracted = mapped.delete(common_attribute)
          extract[common_attribute] = extracted if extracted
        end
      end

      def mapped_from(clazz, key, value) # rubocop:disable Metrics/MethodLength
        if self.class.attribute_methods.include?(key.to_sym)
          # The given attribute name has been defined using the `::attribute`
          # DSL method, so send the given value to that method and return the
          # resulting hash.
          public_send(:"attribute_#{key}", value)
        elsif clazz.prop?(key)
          # The given attribute name is a valid property on the resource, so
          # directly map the attribute to the given value.
          { key.to_sym => value }
        elsif clazz.prop?("#{key}_id")
          # The given attribute name corresponds to a property on the resource
          # that takes the ID of another resource (for example, specifying the
          # vpc option in the file when the resource has a vpc_id property). In
          # this case, automatically convert the given value into a
          # CloudFormation reference.
          { "#{key}_id": Humidifier.ref(value) }
        elsif COMMON_ATTRIBUTES.include?(key.to_sym)
          # The given attribute name is one of the attributes common to all
          # resources (for example creation_policy), so map that directly to the
          # given value.
          { key.to_sym => value }
        else
          # The given attribute name did not match one of the valid options, so
          # raise an error to alert the user.
          raise InvalidResourceAttributeError.new(clazz, key)
        end
      end
    end
  end
end
