require 'test_helper'

class ParserTest < Minitest::Test
  class PropDouble
    def name
      @id ||= 0
      "Prop#{@id += 1}"
    end
  end

  def test_parse
    parser = AwsCF::Parser.new(%w[one two three].join("\n"))
    with_doubled_props do |double|
      assert_equal ({ 'Prop1' => double, 'Prop2' => double, 'Prop3' => double }), parser.parse
    end
  end

  def test_class_parse
    with_doubled_props do |double|
      parser = AwsCF::Parser.parse('one')
      assert_equal ({ 'Prop1' => double }), parser.props
    end
  end

  private

    def with_doubled_props
      double = PropDouble.new
      AwsCF::Props.stub(:from, double) do
        yield double
      end
    end
end
