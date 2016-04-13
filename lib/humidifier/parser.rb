module Humidifier

  # Parses CFN specs
  class Parser

    attr_accessor :props, :spec

    def initialize(spec)
      self.spec = spec
    end

    def parse
      self.props = spec.split("\n").map do |spec_line|
        prop = Props.from(spec_line)
        [prop.name, prop]
      end.to_h
    end

    def self.parse(spec)
      parser = new(spec)
      parser.parse
      parser
    end
  end
end
