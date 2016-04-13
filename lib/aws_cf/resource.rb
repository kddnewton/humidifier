module AwsCF
  class Resource

    attr_accessor :properties

    def initialize(properties = {}, raw = false)
      self.properties = {}
      update(properties, raw)
    end

    def method_missing(name, *args)
      sname = name.to_s

      if (self.class.props.keys & [sname, sname[0..-2]]).empty?
        super
      elsif self.class.props.key?(sname)
        properties[sname]
      else
        update_property(sname[0..-2], args.first)
      end
    end

    def respond_to_missing?(name, *)
      sname = name.to_s
      (self.class.props.keys & [sname, sname[0..-2]]).any? || super
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
      property = Props.convert(property) if raw

      unless self.class.has_prop?(property)
        fail ArgumentError, "Attempting to set invalid property for #{self.class.name}: #{property}"
      end

      value = self.class.props[property].convert(value) if raw && self.class.props[property].convertable?
      unless self.class.props[property].valid?(value)
        fail ArgumentError, "Invalid value for #{property}: #{value.inspect}"
      end
      properties[property] = value
    end

    class << self
      attr_accessor :aws_name, :props, :registry

      def has_prop?(prop)
        props.key?(prop)
      end

      def register(group, resource, spec)
        parser = Parser.parse(spec)
        self.props = parser.props

        resource_class = Class.new(Resource)
        resource_class.props = parser.props
        resource_class.aws_name = (aws_name = "AWS::#{group}::#{resource}")

        AwsCF.const_set(group, Module.new) unless AwsCF.const_defined?(group)
        AwsCF.const_get(group).const_set(resource, resource_class)

        (self.registry ||= {})[aws_name] = resource_class
      end
    end
  end
end
