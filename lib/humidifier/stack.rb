module Humidifier

  # Represents a CFN stack
  class Stack

    attr_accessor :description, :outputs, :resources

    def initialize(opts = {})
      self.description = opts[:description]
      self.outputs     = opts.fetch(:outputs, {})
      self.resources   = opts.fetch(:resources, {})
    end

    def add(name, resource)
      resources[name] = resource
    end

    def add_output(name, opts = {})
      outputs[name] = Output.new(opts)
    end

    def to_cf
      cf = { 'Resources' => Serializer.enumerable_to_h(resources) { |name, resource| [name, resource.to_cf] } }
      cf['Description'] = description if description
      cf['Outputs']     = Serializer.enumerable_to_h(outputs) { |name, output| [name, output.to_cf] } if outputs.any?
      JSON.pretty_generate(cf)
    end

    def valid?
      AWSShim.validate_stack(self)
    end
  end
end
