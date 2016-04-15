require 'test_helper'

class StackTest < Minitest::Test
  ResourceDouble = Struct.new(:to_cf)

  def test_defaults
    stack = Humidifier::Stack.new
    assert_equal nil, stack.description
    assert_equal ({}), stack.resources
  end

  def test_add
    stack = Humidifier::Stack.new
    resource = Object.new
    stack.add('MyResource', resource)

    assert_equal ({ 'MyResource' => resource }), stack.resources
  end

  def test_add_output
    stack = Humidifier::Stack.new
    stack.add_output('foo', value: 'bar')

    assert_equal 'foo', stack.outputs.keys.first
    assert_equal 'bar', stack.outputs.values.first.value
  end

  def test_to_cf
    stack = Humidifier::Stack.new(
      resources: {
        'One' => ResourceDouble.new('One'),
        'Two' => ResourceDouble.new('Two')
      },
      outputs: {
        'Three' => ResourceDouble.new('Three')
      }
    )

    expected = {
      'Resources' => { 'One' => 'One', 'Two' => 'Two' },
      'Outputs' => { 'Three' => 'Three' }
    }
    assert_equal expected, JSON.parse(stack.to_cf)
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
end
