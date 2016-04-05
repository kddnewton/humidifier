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
      cf = { 'AWSTemplateFormatVersion' => '2010-09-09' }
      cf['Description'] = description if description
      cf['Resources'] = resources.map { |name, resource| { name => resource.to_cf } }
      JSON.pretty_generate(cf)
    end
  end
end
