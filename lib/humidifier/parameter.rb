# frozen_string_literal: true

module Humidifier
  class Parameter
    PROPERTIES =
      Humidifier.underscore(
        %w[AllowedPattern AllowedValues ConstraintDescription Default
           Description MaxLength MaxValue MinLength MinValue NoEcho]
      )

    attr_reader :type, *PROPERTIES.values

    def initialize(opts = {})
      PROPERTIES.each_value do |property|
        instance_variable_set(:"@#{property}", opts[property])
      end

      @type = opts.fetch(:type, 'String')
    end

    # CFN stack syntax
    def to_cf
      { 'Type' => type }.tap do |cf|
        PROPERTIES.each do |name, prop|
          value = public_send(prop)
          cf[name] = Serializer.dump(value) if value
        end
      end
    end
  end
end
