module Humidifier
  module AttributeMethods

    ATTRIBUTES = %i[creation_policy deletion_policy depends_on metadata update_policy].freeze
    private_constant :ATTRIBUTES

    def self.included(base)
      base.send(:attr_accessor, *ATTRIBUTES)
    end

    def common_attributes
      ATTRIBUTES.each_with_object({}) do |att, attributes|
        attributes[attr_to_camel(att)] = send(att) if send(att)
      end
    end

    private

    def attr_to_camel(att)
      att.to_s.capitalize.gsub(/_([a-z])/) { $1.upcase }
    end
  end
end
