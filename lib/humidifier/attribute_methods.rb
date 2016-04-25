module Humidifier
  module AttributeMethods

    ATTRIBUTES = %i[condition creation_policy deletion_policy depends_on metadata update_policy].freeze
    private_constant :ATTRIBUTES

    def self.included(base)
      base.send(:attr_accessor, *ATTRIBUTES)
    end

    def common_attributes
      ATTRIBUTES.each_with_object({}) do |att, attributes|
        attributes[Utils.camelize(att)] = send(att) if send(att)
      end
    end
  end
end
