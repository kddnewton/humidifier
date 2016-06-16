module Humidifier

  # Dumps an object to CFN syntax
  module Utils

    # a frozen hash of the given names mapped to their underscored version
    def self.underscored(names)
      names.each_with_object({}) { |name, map| map[name] = underscore(name).to_sym }.freeze
    end
  end
end
