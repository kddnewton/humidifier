module Humidifier

  # Represents a CFN stack output
  class Output

    attr_accessor :description, :value

    def initialize(opts = {})
      self.description = opts[:description]
      self.value       = opts[:value]
    end

    def to_cf
      cf = { 'Value' => Utils.dump(value) }
      cf['Description'] = description if description
      cf
    end
  end
end
