require 'test_helper'

class FullStackTest < Minitest::Test

  ResourceDouble = Struct.new(:to_cf)
  EXPECTED_CF = {
    'AWSTemplateFormatVersion' => 'foo',
    'Description' => 'bar',
    'Metadata' => 'baz',
    'Resources' => { 'One' => 'One', 'Two' => 'Two' },
    'Mappings' => { 'Three' => 'Three' },
    'Outputs' => { 'Four' => 'Four' },
    'Parameters' => { 'Five' => 'Five' },
    'Conditions' => { 'Six' => 'Six' }
  }.freeze

  def test_to_cf
    stack = Humidifier::Stack.new(static_resources.merge(enumerable_resources))
    assert_equal EXPECTED_CF, JSON.parse(stack.to_cf(:json))
    assert_equal EXPECTED_CF, YAML.load(stack.to_cf(:yaml))
  end

  private

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

  def static_resources
    {
      aws_template_format_version: 'foo',
      description: 'bar',
      metadata: 'baz'
    }
  end
end
