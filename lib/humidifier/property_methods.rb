module Humidifier
  module PropertyMethods

    def build_property_reader(name)
      define_method(name) do
        properties[name.to_s]
      end
    end

    def build_property_writer(name)
      define_method(name) do |value|
        update_property(name.to_s[0..-2], value)
      end
    end
  end
end
