module Humidifier

  # Superclass for all AWS resources
  class Resource

    attr_accessor :properties

    def initialize(properties = {}, raw = false)
      self.properties = {}
      update(properties, raw)
    end

    def method_missing(name, *args)
      sname = name.to_s

      if !valid_accessor?(name)
        super
      elsif self.class.props.key?(sname)
        properties[sname]
      else
        update_property(sname[0..-2], args.first)
      end
    end

    def respond_to_missing?(name, *)
      valid_accessor?(name) || super
    end

    def to_cf
      props_cf = properties.map do |key, value|
        self.class.props[key].to_cf(value)
      end.to_h

      { 'Type' => self.class.aws_name, 'Properties' => props_cf }
    end

    def update(properties, raw = false)
      properties.each { |property, value| update_property(property.to_s, value, raw) }
    end

    def update_property(property, value, raw = false)
      property = validate_property(property, raw)
      value = validate_value(property, value, raw)
      properties[property] = value
    end

    private

    def valid_accessor?(method)
      (self.class.props.keys & [method.to_s, method.to_s[0..-2]]).any?
    end

    def validate_property(property, raw)
      property = Props.convert(property) if raw
      unless self.class.prop?(property)
        raise ArgumentError, "Attempting to set invalid property for #{self.class.name}: #{property}"
      end
      property
    end

    def validate_value(property, value, raw)
      value = self.class.props[property].convert(value) if raw && self.class.props[property].convertable?
      unless self.class.props[property].valid?(value)
        raise ArgumentError, "Invalid value for #{property}: #{value.inspect}"
      end
      value
    end

    class << self
      attr_accessor :aws_name, :props, :registry

      def prop?(prop)
        props.key?(prop)
      end

      def register(group, resource, spec)
        aws_name = "AWS::#{group}::#{resource}"
        resource_class = build_class(aws_name, spec)

        Humidifier.const_set(group, Module.new) unless Humidifier.const_defined?(group)
        Humidifier.const_get(group).const_set(resource, resource_class)
        (self.registry ||= {})[aws_name] = resource_class
      end

      private

      def build_class(aws_name, spec)
        Class.new(self) do
          self.aws_name = aws_name
          self.props = spec.split("\n").map do |spec_line|
            prop = Props.from(spec_line)
            [prop.name, prop]
          end.to_h
        end
      end
    end
  end
end
