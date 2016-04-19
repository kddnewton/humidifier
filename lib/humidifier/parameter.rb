module Humidifier

  # Represents a CFN stack parameter
  class Parameter
    PROPERTIES = %i[allowed_pattern allowed_values constraint_description default description max_length max_value
                    min_length min_value no_echo].freeze
    private_constant :PROPERTIES

    attr_accessor :type, *PROPERTIES

    def initialize(opts = {})
      PROPERTIES.each { |prop| send(:"#{prop}=", opts[prop]) }
      self.type = opts.fetch(:type, 'String')
    end

    def to_cf
      cf = { 'Type' => type }
      PROPERTIES.each do |prop|
        val = send(prop)
        cf[prop_to_camel(prop)] = Serializer.dump(val) if val
      end
      cf
    end

    private

    def prop_to_camel(prop)
      prop.to_s.capitalize.gsub(/_([a-z])/) { $1.upcase }
    end
  end
end
