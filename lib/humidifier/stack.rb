module Humidifier

  # Represents a CFN stack
  class Stack

    STATIC_RESOURCES     = %i[aws_template_format_version description metadata].freeze
    ENUMERABLE_RESOURCES = %i[mappings outputs parameters resources].freeze
    private_constant :STATIC_RESOURCES, :ENUMERABLE_RESOURCES

    attr_accessor(*STATIC_RESOURCES)
    attr_accessor(*ENUMERABLE_RESOURCES)

    def initialize(opts = {})
      STATIC_RESOURCES.each do |resource_type|
        send(:"#{resource_type}=", opts[resource_type])
      end
      ENUMERABLE_RESOURCES.each do |resource_type|
        send(:"#{resource_type}=", opts.fetch(resource_type, {}))
      end
    end

    def add(name, resource)
      resources[name] = resource
    end

    %i[mapping output parameter].each do |resource_type|
      define_method(:"add_#{resource_type}") do |name, opts = {}|
        send(:"#{resource_type}s")[name] = Humidifier.const_get(resource_type.capitalize).new(opts)
      end
    end

    def to_cf
      cf = {}
      STATIC_RESOURCES.each do |resource_type|
        cf = add_static_resource(cf, resource_type)
      end
      ENUMERABLE_RESOURCES.each do |resource_type|
        cf = add_enumerable_resources(cf, resource_type)
      end

      JSON.pretty_generate(cf)
    end

    def valid?
      AwsShim.validate_stack(self)
    end

    private

    def add_static_resource(cf, resource_type)
      cf[Utils.camelize(resource_type)] = send(resource_type) if send(resource_type)
      cf
    end

    def add_enumerable_resources(cf, resource_type)
      if send(resource_type).any?
        key = Utils.camelize(resource_type)
        cf[key] = Serializer.enumerable_to_h(send(resource_type)) do |name, resource|
          [name, resource.to_cf]
        end
      end
      cf
    end
  end
end
