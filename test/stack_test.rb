require 'test_helper'

class StackTest < Minitest::Test
  ResourceDouble = Struct.new(:to_cf)

  def test_defaults
    stack = Humidifier::Stack.new
    Humidifier::Stack.const_get(:STATIC_RESOURCES).each do |resource_type|
      assert_equal nil, stack.send(resource_type)
    end
    Humidifier::Stack.const_get(:ENUMERABLE_RESOURCES).each do |resource_type|
      assert_equal ({}), stack.send(resource_type)
    end
  end

  def test_add
    stack = Humidifier::Stack.new
    resource = Object.new
    stack.add('MyResource', resource)

    assert_equal ({ 'MyResource' => resource }), stack.resources
  end

  def test_add_condition
    stack = Humidifier::Stack.new
    stack.add_condition('foo', 'bar' => 'baz')

    assert_equal 'foo', stack.conditions.keys.first
    assert_equal 'baz', stack.conditions.values.first.opts.values.first
  end

  def test_add_mapping
    stack = Humidifier::Stack.new
    stack.add_mapping('foo', 'bar' => 'baz')

    assert_equal 'foo', stack.mappings.keys.first
    assert_equal 'baz', stack.mappings.values.first.opts.values.first
  end

  def test_add_output
    stack = Humidifier::Stack.new
    stack.add_output('foo', value: 'bar')

    assert_equal 'foo', stack.outputs.keys.first
    assert_equal 'bar', stack.outputs.values.first.value
  end

  def test_add_parameter
    stack = Humidifier::Stack.new
    stack.add_parameter('foo', type: 'bar')

    assert_equal 'foo', stack.parameters.keys.first
    assert_equal 'bar', stack.parameters.values.first.type
  end

  def test_to_cf
    expected = {
      'AWSTemplateFormatVersion' => 'foo',
      'Description' => 'bar',
      'Metadata' => 'baz',
      'Resources' => { 'One' => 'One', 'Two' => 'Two' },
      'Mappings' => { 'Three' => 'Three' },
      'Outputs' => { 'Four' => 'Four' },
      'Parameters' => { 'Five' => 'Five' },
      'Conditions' => { 'Six' => 'Six' }
    }
    assert_equal expected, JSON.parse(build.to_cf)
  end

  def test_valid?
    stack = Humidifier::Stack.new
    mock = Minitest::Mock.new
    mock.expect(:call, nil, [stack])

    Humidifier::AWSShim.stub(:validate_stack, mock) do
      stack.valid?
    end
    mock.verify
  end

  private

  def build
    Humidifier::Stack.new(static_resources.merge(enumerable_resources))
  end

  def static_resources
    {
      aws_template_format_version: 'foo',
      description: 'bar',
      metadata: 'baz'
    }
  end

  def enumerable_resources
    {
      resources: {
        'One' => ResourceDouble.new('One'),
        'Two' => ResourceDouble.new('Two')
      },
      mappings: { 'Three' => ResourceDouble.new('Three') },
      outputs: { 'Four' => ResourceDouble.new('Four') },
      parameters: { 'Five' => ResourceDouble.new('Five') },
      conditions: { 'Six' => ResourceDouble.new('Six') }
    }
  end
end
