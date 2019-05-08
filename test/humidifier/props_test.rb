# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class PropsTest < Minitest::Test
    def test_list
      config = { 'Type' => 'List', 'PrimitiveType' => 'Integer' }
      prop = Props.from('list', config)
      assert_kind_of Props::ListProp, prop
      assert_equal 'list', prop.key
    end

    def test_map
      config = { 'Type' => 'Map', 'PrimitiveType' => 'Integer' }
      prop = Props.from('map', config)
      assert_kind_of Props::MapProp, prop
      assert_equal 'map', prop.key
    end

    def test_boolean
      prop = Props.from('boolean', 'PrimitiveType' => 'Boolean')
      assert_kind_of Props::BooleanProp, prop
      assert_equal 'boolean', prop.key
    end

    def test_double
      prop = Props.from('double', 'PrimitiveType' => 'Double')
      assert_kind_of Props::DoubleProp, prop
      assert_equal 'double', prop.key
    end

    def test_integer
      prop = Props.from('integer', 'PrimitiveType' => 'Integer')
      assert_kind_of Props::IntegerProp, prop
      assert_equal 'integer', prop.key
    end

    def test_json
      prop = Props.from('json', 'PrimitiveType' => 'Json')
      assert_kind_of Props::JsonProp, prop
      assert_equal 'json', prop.key
    end

    def test_string
      prop = Props.from('string', 'PrimitiveType' => 'String')
      assert_kind_of Props::StringProp, prop
      assert_equal 'string', prop.key
    end

    def test_structure
      substructs = {
        'Foobar' => {
          'Properties' => { 'Alpha' => { 'PrimitiveType' => 'String' } }
        }
      }

      config = { 'Type' => 'Foobar' }
      prop = Props.from('structure', config, substructs)
      assert_kind_of Props::StructureProp, prop
      assert_equal 'structure', prop.key
    end
  end
end
