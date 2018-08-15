# frozen_string_literal: true

module Humidifier
  # Represents a CFN stack output
  class Output
    attr_reader :description, :value, :export_name

    def initialize(opts = {})
      @description = opts[:description]
      @value       = opts[:value]
      @export_name = opts[:export_name]
    end

    # CFN stack syntax
    def to_cf
      cf = { 'Value' => Serializer.dump(value) }
      cf['Description'] = description if description
      cf['Export'] = { 'Name' => export_name } if export_name
      cf
    end
  end
end
