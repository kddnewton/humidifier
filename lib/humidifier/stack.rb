module Humidifier

  # Represents a CFN stack
  class Stack

    STATIC_RESOURCES     = Utils.underscored(%w[AWSTemplateFormatVersion Description Metadata])
    ENUMERABLE_RESOURCES = Utils.underscored(%w[Mappings Outputs Parameters Resources])

    attr_accessor :id, :name, *STATIC_RESOURCES.values, *ENUMERABLE_RESOURCES.values

    def initialize(opts = {})
      self.name = opts[:name]
      self.id   = opts[:id]

      STATIC_RESOURCES.values.each do |prop|
        send(:"#{prop}=", opts[prop])
      end
      ENUMERABLE_RESOURCES.values.each do |prop|
        send(:"#{prop}=", opts.fetch(prop, {}))
      end
    end

    def add(name, resource)
      resources[name] = resource
    end

    def identifier
      id || name
    end

    def to_cf
      cf = {}

      STATIC_RESOURCES.each do |name, prop|
        resource = send(prop)
        cf[name] = resource if resource
      end

      ENUMERABLE_RESOURCES.each do |name, prop|
        resources = send(prop)
        next if resources.empty?
        cf[name] = Utils.enumerable_to_h(resources) do |resource_name, resource|
          [resource_name, resource.to_cf]
        end
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
  end
end
