module Humidifier
  # Dumps an object to CFN syntax
  module Utils
    # convert from UpperCamelCase to lower_snake_case
    def self.underscore(name)
      return nil unless name
      name.gsub(/([A-Z]+)([0-9]|[A-Z]|\z)/) { "#{$1.capitalize}#{$2}" }
          .gsub(/(.)([A-Z])/, '\1_\2').downcase
    end

    # a frozen hash of the given names mapped to their underscored version
    def self.underscored(names)
      names.map { |name| [name, underscore(name).to_sym] }.to_h.freeze
    end
  end
end
