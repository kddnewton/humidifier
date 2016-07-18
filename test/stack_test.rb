require 'test_helper'

class StackTest < Minitest::Test

  def test_defaults
    stack = Humidifier::Stack.new
    Humidifier::Stack::STATIC_RESOURCES.values.each do |prop|
      assert_equal nil, stack.send(prop)
    end
    Humidifier::Stack::ENUMERABLE_RESOURCES.values.each do |prop|
      assert_equal ({}), stack.send(prop)
    end
  end

  def test_add
    stack = Humidifier::Stack.new
    resource = Object.new
    stack.add('MyResource', resource)

    assert_equal ({ 'MyResource' => resource }), stack.resources
  end

  def test_add_with_attributes
    attributes = %w[alpha beta]
    mock = Minitest::Mock.new
    mock.expect(:update_attributes, nil, [attributes])

    stack = Humidifier::Stack.new
    stack.add('MyResource', mock, attributes)
    assert_mock mock
  end

  def test_add_condition
    stack = Humidifier::Stack.new
    stack.add_condition('foo', Humidifier.fn.if('Bar'))

    conditions = stack.conditions
    assert_equal ['foo'], conditions.keys

    opts = conditions.values.first.opts
    assert_equal 'Fn::If', opts.name
    assert_equal 'Bar', opts.value
  end

  def test_identifier
    stack = Humidifier::Stack.new(id: 'foo', name: 'bar')
    assert_equal 'foo', stack.identifier
  end

  def test_identifier_no_id
    stack = Humidifier::Stack.new(name: 'foobar')
    assert_equal 'foobar', stack.identifier
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

  Humidifier::AwsShim::STACK_METHODS.each do |method|
    define_method(:"test_#{method}") do
      with_mocked_aws_shim(method) { |stack| stack.send(method) }
    end
  end

  private

  def with_mocked_aws_shim(method)
    stack = Humidifier::Stack.new(name: 'test-stack')
    mock = Minitest::Mock.new
    mock.expect(:call, nil, [Humidifier::SdkPayload.new(stack, {})])

    Humidifier::AwsShim.stub(method, mock) do
      yield stack
    end
    mock.verify
  end
end
