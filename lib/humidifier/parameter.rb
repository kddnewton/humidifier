module Humidifier

  # Represents a CFN stack parameter
  class Parameter

    PROPERTIES = Utils.underscored(%w[AllowedPattern AllowedValues ConstraintDescription Default Description
                                      MaxLength MaxValue MinLength MinValue NoEcho])

    attr_accessor :type, *PROPERTIES.values

    def initialize(opts = {})
      PROPERTIES.values.each { |prop| send(:"#{prop}=", opts[prop]) }
      self.type = opts.fetch(:type, 'String')
    end

    def to_cf
      cf = { 'Type' => type }
      PROPERTIES.each do |name, prop|
        val = send(prop)
        cf[name] = Serializer.dump(val) if val
      end
      cf
    end
  end
end
