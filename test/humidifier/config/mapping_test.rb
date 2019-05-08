# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class Config
    class MappingTest < Minitest::Test
      def test_invalid_resource
        assert_raises Error do
          Mapping.new(to: 'invalid')
        end
      end

      def test_resource_for_base_mapper
        mapping = Mapping.new(to: 'AWS::IAM::User')
        resource = mapping.resource_for('TestUser', 'user_name' => 'TestUser')

        assert_kind_of IAM::User, resource
        assert_equal 'TestUser', resource.user_name
      end

      def test_resource_for_allows_dropping_aws
        mapping = Mapping.new(to: 'IAM::User')
        assert_kind_of IAM::User, mapping.resource_for('TestUser', {})
      end

      def test_resource_for_foobar_mapper
        mapping = Mapping.new(to: 'AWS::IAM::User', using: FoobarMapper)
        mapping.instance_variable_set(:@clazz, FoobarResource)

        resource = mapping.resource_for('1', 'bar' => '2', 'baz' => '3')
        assert_kind_of FoobarResource, resource

        expected = { 'foo' => '1', 'bar' => '2', 'baz' => '3' }
        assert_equal expected, resource.to_cf['Properties']
      end

      def test_anonymous_mappers
        mapping =
          Mapping.new(to: 'AWS::IAM::User') do
            attribute(:testing) { |testing| { testing: testing } }
          end

        actual = mapping.mapper.attribute_testing('foobar')
        assert_equal({ testing: 'foobar' }, actual)
      end

      def test_blocks_using_and_anonymous_mappers
        assert_raises Error do
          Mapping.new(to: 'AWS::IAM::User', using: FoobarMapper) {}
        end
      end
    end
  end
end
