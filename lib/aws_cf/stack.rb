module AwsCF
  class Stack

    attr_accessor :description, :resources

    def initialize(args = {})
      self.description = args[:description]
      self.resources   = args.fetch(:resources, {})
    end

    def add(name, resource)
      resources[name] = resource
    end

    def to_cf
      cf['Resources'] = resources.map { |name, resource| [name, resource.to_cf] }.to_h
      cf['Description'] = description if description
      JSON.pretty_generate(cf)
    end
  end
end
