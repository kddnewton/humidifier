module Humidifier
  # Dumps an object to CFN syntax
  module Utils
    # a frozen hash of the given names mapped to their underscored version
    def self.underscored(names)
      names.map { |name| [name, underscore(name).to_sym] }.to_h.freeze
    end
  end
end
