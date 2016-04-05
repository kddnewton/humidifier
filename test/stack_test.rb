require 'test_helper'

class StackTest < Minitest::Test
  ResourceDouble = Struct.new(:to_cf)

  def test_defaults
    stack = AwsCF::Stack.new
    assert_equal nil, stack.description
    assert_equal ({}), stack.resources
  end

  def test_add
    stack = AwsCF::Stack.new
    resource = Object.new
    stack.add('MyResource', resource)

    assert_equal ({ 'MyResource' => resource }), stack.resources
  end

  def test_to_cf
    stack = AwsCF::Stack.new(resources: {
      'One' => ResourceDouble.new('One'),
      'Two' => ResourceDouble.new('Two')
    })

    assert_equal ({ 'Resources' => { 'One' => 'One', 'Two' => 'Two' } }), JSON.parse(stack.to_cf)
  end
end
