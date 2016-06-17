module Humidifier
  # Pre-setting this module because AWS has a "Config" module and the below register method dynamically looks up the
  # module to see whether or not it exists, which before ruby 2.2 would result in the warning:
  #   `const_defined?': Use RbConfig instead of obsolete and deprecated Config.
  # @aws AWS::Config
  module Config
  end

  # Reads each of the files under /specs/ and loads them each as a class
  class Loader

    # loop through the specs and register each class
    def load
      spec_directory = File.expand_path(File.join('..', '..', '..', 'specs', '*'), __FILE__)
      Dir[spec_directory].each { |filepath| load_from(filepath) }
    end

    # convenience class method to build a new loader and call load
    def self.load
      new.load
    end

    private

    def build_class(aws_name, spec)
      Class.new(Resource) do
        self.aws_name = aws_name
        self.props = spec.each_with_object({}) do |spec_line, props|
          prop = Props.from(spec_line)
          props[prop.name] = prop unless prop.name.nil?
        end
      end
    end

    def load_from(filepath)
      group, resource = Pathname.new(filepath).basename('.cf').to_s.split('-')
      spec = File.readlines(filepath).select do |line|
        # flipflop operator (http://stackoverflow.com/questions/14456634)
        true if line.include?('Properties')...(line.strip == '}')
      end
      register(group, resource, spec[1..-2])
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
