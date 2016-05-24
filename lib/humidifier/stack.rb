module Humidifier

  # Represents a CFN stack
  class Stack

    ENUMERABLE_RESOURCES = Utils.underscored(%w[Mappings Outputs Parameters Resources])
    STATIC_RESOURCES     = Utils.underscored(%w[AWSTemplateFormatVersion Description Metadata])

    attr_accessor :id, :name, *ENUMERABLE_RESOURCES.values, *STATIC_RESOURCES.values

    def initialize(opts = {})
      self.name = opts[:name]
      self.id   = opts[:id]

      ENUMERABLE_RESOURCES.values.each { |prop| send(:"#{prop}=", opts.fetch(prop, {})) }
      STATIC_RESOURCES.values.each { |prop| send(:"#{prop}=", opts[prop]) }
    end

    def add(name, resource)
      resources[name] = resource
    end

    def identifier
      id || name
    end

    def to_cf
      JSON.pretty_generate(enumerable_resources.merge(static_resources))
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

    def enumerable_resources
      ENUMERABLE_RESOURCES.each_with_object({}) do |(name, prop), list|
        resources = send(prop)
        next if resources.empty?
        list[name] = Utils.enumerable_to_h(resources) do |resource_name, resource|
          [resource_name, resource.to_cf]
        end
      end
    end

    def static_resources
      STATIC_RESOURCES.each_with_object({}) do |(name, prop), list|
        resource = send(prop)
        list[name] = resource if resource
      end
    end
  end
end
