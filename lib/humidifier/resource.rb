module Humidifier

  # Superclass for all AWS resources
  class Resource

    extend PropertyMethods

    COMMON_ATTRIBUTES = %i[creation_policy deletion_policy depends_on metadata update_policy].freeze
    private_constant :COMMON_ATTRIBUTES

    attr_accessor :properties, *COMMON_ATTRIBUTES

    def initialize(properties = {}, raw = false)
      self.properties = {}
      update(properties, raw)
    end

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

    def respond_to_missing?(name, *)
      valid_accessor?(name) || super
    end

    def to_cf
      props_cf = Serializer.enumerable_to_h(properties) { |(key, value)| self.class.props[key].to_cf(value) }
      { 'Type' => self.class.aws_name, 'Properties' => props_cf }.merge(common_attributes)
    end

    def update(properties, raw = false)
      properties.each { |property, value| update_property(property, value, raw) }
    end

    def update_property(property, value, raw = false)
      property = property.to_s
      property = validate_property(property, raw)
      value = validate_value(property, value, raw)
      properties[property] = value
    end

    private

    def common_attributes
      COMMON_ATTRIBUTES.each_with_object({}) do |attribute, result|
        value = send(attribute)
        result[Utils.camelize(attribute)] = value if value
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
      value = prop.convert(value) if raw && prop.convertable?
      unless prop.valid?(value)
        raise ArgumentError, "Invalid value for #{property}: #{value.inspect}"
      end
      value
    end

    class << self
      attr_accessor :aws_name, :props

      def prop?(prop)
        props.key?(prop)
      end
    end
  end
end
