module Humidifier
  # Pre-setting this module because AWS has a "Config" module and the below register method dynamically looks up the
  # module to see whether or not it exists, which before ruby 2.2 would result in the warning:
  #   `const_defined?': Use RbConfig instead of obsolete and deprecated Config.
  # @aws AWS::Config
  module Config
  end

  # Reads the lib/specs.json file and load each resource as a class
  class Loader

    # loop through the specs and register each class
    def load
      filepath = File.expand_path(File.join('..', '..', 'specs.json'), __FILE__)
      JSON.parse(File.read(filepath))['ResourceTypes'].each do |key, spec|
        match = key.match(/\AAWS::(\w+)::(\w+)\z/)
        register(match[1], match[2], spec)
      end
    end

    # convenience class method to build a new loader and call load
    def self.load
      new.load
    end

    private

    def build_class(aws_name, spec)
      Class.new(Resource) do
        self.aws_name = aws_name
        self.props =
          Utils.enumerable_to_h(spec['Properties']) do |(key, config)|
            prop = Props.from(key, config)
            [prop.name, prop]
          end
      end
    end

    def register(group, resource, spec)
      aws_name = "AWS::#{group}::#{resource}"
      resource_class = build_class(aws_name, spec)

      Humidifier.const_set(group, Module.new) unless Humidifier.const_defined?(group)
      Humidifier.const_get(group).const_set(resource, resource_class)
      Humidifier.registry[aws_name] = resource_class
    end
  end
end
