module Humidifier

  # Represents a CFN stack
  class Stack

    # Single settings on the stack
    STATIC_RESOURCES     = %i[aws_template_format_version description metadata].freeze

    # Lists of objects linked to the stack
    ENUMERABLE_RESOURCES = %i[mappings outputs parameters resources].freeze

    attr_accessor :id, :name, *STATIC_RESOURCES, *ENUMERABLE_RESOURCES

    # Configure settings based on given opts
    def initialize(opts = {})
      self.name = opts[:name]
      self.id   = opts[:id]

      STATIC_RESOURCES.each do |resource_type|
        send(:"#{resource_type}=", opts[resource_type])
      end
      ENUMERABLE_RESOURCES.each do |resource_type|
        send(:"#{resource_type}=", opts.fetch(resource_type, {}))
      end
    end

    # Add a resource to the stack
    def add(name, resource)
      resources[name] = resource
    end

    # The identifier used by the shim to find the stack in CFN, prefers id to name
    def identifier
      id || name
    end

    # A string representation of the stack that's valid for CFN
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

    %i[mapping output parameter].each do |resource_type|
      define_method(:"add_#{resource_type}") do |name, opts = {}|
        send(:"#{resource_type}s")[name] = Humidifier.const_get(resource_type.capitalize).new(opts)
      end
    end

    AwsShim::STACK_METHODS.each do |method|
      define_method(method) { |opts = {}| AwsShim.send(method, SdkPayload.new(self, opts)) }
    end

    private

    def add_static_resource(cf, resource_type)
      resource = send(resource_type)
      cf[Utils.camelize(resource_type)] = resource if resource
      cf
    end

    def add_enumerable_resources(cf, resource_type)
      resources = send(resource_type)
      if resources.any?
        key = Utils.camelize(resource_type)
        cf[key] = Serializer.enumerable_to_h(resources) do |name, resource|
          [name, resource.to_cf]
        end
      end
      cf
    end
  end
end
