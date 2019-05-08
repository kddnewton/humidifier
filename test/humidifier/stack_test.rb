# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class StackTest < Minitest::Test
    def test_defaults
      reset_stack_count
      stack = Stack.new

      assert_match(/1\z/, stack.identifier)
      Stack::STATIC_RESOURCES.each_value do |prop|
        assert_nil stack.send(prop)
      end
      Stack::ENUMERABLE_RESOURCES.each_value do |prop|
        assert_equal ({}), stack.send(prop)
      end
    end

    def test_add
      stack = Stack.new
      resource = Object.new
      stack.add('MyResource', resource)

      assert_equal ({ 'MyResource' => resource }), stack.resources
    end

    def test_add_with_attributes
      attributes = %w[alpha beta]
      mock = Minitest::Mock.new
      mock.expect(:update_attributes, nil, [attributes])

      stack = Stack.new
      stack.add('MyResource', mock, attributes)
      assert_mock mock
    end

    def test_add_condition
      stack = Stack.new
      stack.add_condition('foo', Humidifier.fn.if('Bar'))

      conditions = stack.conditions
      assert_equal ['foo'], conditions.keys

      opts = conditions.values.first.opts
      assert_equal 'Fn::If', opts.name
      assert_equal 'Bar', opts.value
    end

    def test_identifier
      stack = Stack.new(id: 'foo', name: 'bar')
      assert_equal 'foo', stack.identifier
    end

    def test_identifier_no_id
      stack = Stack.new(name: 'foobar')
      assert_equal 'foobar', stack.identifier
    end

    def test_add_mapping
      stack = Stack.new
      stack.add_mapping('foo', 'bar' => 'baz')

      assert_equal 'foo', stack.mappings.keys.first
      assert_equal 'baz', stack.mappings.values.first.opts.values.first
    end

    def test_add_output
      stack = Stack.new
      stack.add_output('foo', value: 'bar')

      assert_equal 'foo', stack.outputs.keys.first
      assert_equal 'bar', stack.outputs.values.first.value
    end

    def test_add_parameter
      stack = Stack.new
      stack.add_parameter('foo', type: 'bar')

      assert_equal 'foo', stack.parameters.keys.first
      assert_equal 'bar', stack.parameters.values.first.type
    end

    def test_class_next_default_identifier
      reset_stack_count
      (1..5).each do |num|
        assert_match(/#{num}\z/, Stack.next_default_identifier)
      end
    end

    private

    def reset_stack_count
      Stack.instance_variable_set(:@count, nil)
    end
  end
end
