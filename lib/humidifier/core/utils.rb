module Humidifier
  module Core

    # Dumps an object to CFN syntax
    module Utils

      class << self
        # back-supporting ruby 2.0's lack of Enumerable#to_h
        def enumerable_to_h(enumerable)
          enumerable.each_with_object({}) do |item, result|
            key, value = yield item
            result[key] = value
          end
        end

        # a frozen hash of the given names mapped to their underscored version
        def underscored(names)
          names.each_with_object({}) { |name, map| map[name] = underscore(name).to_sym }.freeze
        end
      end
    end
  end
end
