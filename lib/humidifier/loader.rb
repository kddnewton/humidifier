module Humidifier
  module Loader

    class << self
      # loop through the specs and register each class
      def load
        silence_warnings do
          Dir[File.expand_path(File.join('..', '..', '..', 'specs', '*'), __FILE__)].each do |filepath|
            group, resource = Pathname.new(filepath).basename('.cf').to_s.split('-')
            spec = File.readlines(filepath).select do |line|
              # flipflop operator (http://stackoverflow.com/questions/14456634)
              true if line.include?('Properties')...(line.strip == '}')
            end
            Humidifier::Resource.register(group, resource, spec[1..-2])
          end
        end
      end

      private

      # This craziness because AWS has a "Config" module and Humidifier::Resource.register dynamically looks
      # up the module to see whether or not it exists, which before ruby 2.2 would result in the warning:
      #   `const_defined?': Use RbConfig instead of obsolete and deprecated Config.
      # If this is being run with RUBY_VERSION > 2.2.0 this is effectively a noop.
      def silence_warnings
        old_verbose = $VERBOSE
        begin
          $VERBOSE = (RUBY_VERSION < '2.2.0') ? nil : old_verbose
          yield
        ensure
          $VERBOSE = old_verbose
        end
      end
    end
  end
end
