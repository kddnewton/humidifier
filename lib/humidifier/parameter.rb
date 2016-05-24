module Humidifier

  # Represents a CFN stack parameter
  class Parameter

    # The allowed properties of all stack parameters
    PROPERTIES = %i[allowed_pattern allowed_values constraint_description default description max_length max_value
                    min_length min_value no_echo].freeze

    attr_accessor :type, *PROPERTIES

    # Store any optional opts, defaulting 'Type' to String
    def initialize(opts = {})
      PROPERTIES.each { |prop| send(:"#{prop}=", opts[prop]) }
      self.type = opts.fetch(:type, 'String')
    end

    # CFN stack syntax
    def to_cf
      cf = { 'Type' => type }
      PROPERTIES.each do |prop|
        val = send(prop)
        cf[Utils.camelize(prop)] = Serializer.dump(val) if val
      end
      cf
    end
  end
end
