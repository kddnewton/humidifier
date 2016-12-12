module Humidifier

  # Superclass for all AWS resources
  class Resource

    # Attributes that are available to every stack
    COMMON_ATTRIBUTES =
      Utils.underscored(%w[Condition CreationPolicy DeletionPolicy DependsOn Metadata UpdatePolicy])

    attr_accessor :properties, *COMMON_ATTRIBUTES.values

    def initialize(properties = {}, raw = false)
      self.properties = {}
      update(properties, raw)
    end

    # Patches method_missing to include property accessors
    # After the first method call, builds the accessor methods to get a speed boost
    def method_missing(name, *args)
      if !valid_accessor?(name)
        super
      elsif self.class.prop?(name.to_s)
        self.class.build_property_reader(name)
        send(name)
      else
        self.class.build_property_writer(name)
        send(name, args.first)
      end
    end

    # Patches respond_to_missing? to include property accessors
    def respond_to_missing?(name, *)
      valid_accessor?(name) || super
    end

    # CFN stack syntax
    def to_cf
      props_cf = Utils.enumerable_to_h(properties) { |(key, value)| self.class.props[key].to_cf(value) }
      { 'Type' => self.class.aws_name, 'Properties' => props_cf }.merge(common_attributes)
    end

    # Update a set of properties defined by the given properties hash
    def update(properties, raw = false)
      properties.each { |property, value| update_property(property, value, raw) }
    end

    # Update the attributes of the resource defined by COMMON_ATTRIBUTES
    def update_attributes(attributes)
      attributes.each do |attribute, value|
        raise ArgumentError, "Invalid attribute: #{attribute}" unless COMMON_ATTRIBUTES.value?(attribute)
        public_send(:"#{attribute}=", value)
      end
    end

    # Update an individual property on this resource
    def update_property(property, value, raw = false)
      property = property.to_s
      property = validate_property(property, raw)
      value = validate_value(property, value, raw)
      properties[property] = value
    end

    class << self
      attr_accessor :aws_name, :props

      # @private builds a cached method for a property reader
      def build_property_reader(name)
        define_method(name) do
          properties[name.to_s]
        end
      end

      # @private builds a cached method for a property writer
      def build_property_writer(name)
        define_method(name) do |value|
          update_property(name.to_s[0..-2], value)
        end
      end

      # true if this resource has the given property
      def prop?(prop)
        props.key?(prop)
      end
    end

    private

    def common_attributes
      COMMON_ATTRIBUTES.each_with_object({}) do |(name, prop), result|
        value = send(prop)
        result[name] = value if value
      end
    end

    def valid_accessor?(method)
      (self.class.props.keys & [method.to_s, method.to_s[0..-2]]).any?
    end

    def validate_property(property, raw)
      property = Utils.underscore(property) if raw
      unless self.class.prop?(property)
        raise ArgumentError, "Attempting to set invalid property for #{self.class.name}: #{property}"
      end
      property
    end

    def validate_value(property, value, raw)
      prop = self.class.props[property]
      value = prop.convert(value) if raw
      unless prop.valid?(value)
        raise ArgumentError, "Invalid value for #{property}: #{value.inspect}"
      end
      value
    end
  end
end
