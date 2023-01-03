# frozen_string_literal: true

require "test_helper"

module Humidifier
  class Config
    class MapperTest < Minitest::Test
      def test_class_attribute_methods
        assert_equal %i[bar], FoobarMapper.attribute_methods
      end

      def test_resource_for
        resource = resource_for("bar" => "bar_value", "baz" => "baz_value")
        assert_kind_of FoobarResource, resource

        expected = {
          "foo" => "Foo",
          "bar" => "bar_value",
          "baz" => "baz_value"
        }

        assert_equal expected, resource.to_cf["Properties"]
      end

      def test_substitutes_ids
        resource = resource_for("zaz" => "zaz_value")

        assert_equal "zaz_value", resource.to_cf["Properties"]["zaz_id"]["Ref"]
      end

      def test_extracts_common_attributes
        resource = resource_for("foo" => "Foo", "depends_on" => "Something")

        assert_equal "Something", resource.depends_on
      end

      def test_invalid_attribute
        assert_raises Error do
          resource_for("invalid" => "invalid")
        end
      end

      private

      def resource_for(properties)
        FoobarMapper.new.resource_for(FoobarResource, "Foo", properties)
      end
    end
  end
end
