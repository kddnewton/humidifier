module Humidifier

  # Represents a CFN stack
  class Stack

    attr_accessor :description, :mappings, :outputs, :parameters, :resources

    def initialize(opts = {})
      self.description = opts[:description]
      %i[mappings outputs parameters resources].each do |resource_type|
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
      cf = add_description(cf)
      %i[mappings outputs parameters resources].each do |resource_type|
        cf = add_enumerable_resources(cf, resource_type)
      end

      JSON.pretty_generate(cf)
    end

    def valid?
      AWSShim.validate_stack(self)
    end

    private

    def add_description(cf)
      cf['Description'] = description if description
      cf
    end

    def add_enumerable_resources(cf, resource_type)
      if send(resource_type).any?
        cf[resource_type.capitalize.to_s] = Serializer.enumerable_to_h(send(resource_type)) do |name, resource|
          [name, resource.to_cf]
        end
      end
      cf
    end
  end
end
