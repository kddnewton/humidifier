require 'test_helper'

class ApiDocsTest < Minitest::Test

  # Because SimpleCov is based on TracePoint, every time you call Kernel#load the coverage information for the given
  # file gets reset. Therefore, the tests in this file need to be run sequentially so we can ensure that the last
  # test to get run is the one that covers all possible lines and we can maintain 100% test coverage.
  i_suck_and_my_tests_are_order_dependent!

  EXPECTED_MAIN = <<EXP.chomp
# API Reference

- ModA
  - [Instance](#humidifiermodainstance)
- ModB
  - [NetworkAcl](#humidifiermodbnetworkacl)
  - [SecurityGroup](#humidifiermodbsecuritygroup)

### Humidifier::ModA::Instance

* One (one: Fake)
* Two (two: Fake)

### Humidifier::ModB::NetworkAcl

* Four (four: Fake)
* Three (three: Fake)

### Humidifier::ModB::SecurityGroup

* Five (five: Fake)
EXP

  FakeIO = Struct.new(:written) do
    def write(output)
      written << output
    end
  end

  FakeProp = Struct.new(:key) do
    def <=>(other)
      key <=> other.key
    end
  end

  FakeResource = Struct.new(:props)

  def test_base
    output = with_registry { with_file { load_script } }
    assert_equal '# API Reference', output.strip
  end

  def test_main
    registry = {
      'AWS::ModA::Instance' => registry_entry('one', 'two'),
      'AWS::ModB::NetworkAcl' => registry_entry('three', 'four'),
      'AWS::ModB::SecurityGroup' => registry_entry('five')
    }
    output = with_registry(registry) { with_file { load_script } }
    assert_equal EXPECTED_MAIN, output.strip
  end

  private

  def load_script
    load File.expand_path(File.join('..', '..', 'bin', 'api-docs'), __FILE__)
  end

  def registry_entry(*props)
    FakeResource.new(props.each_with_object({}) { |prop, result| result[prop.capitalize] = FakeProp.new(prop) })
  end

  def with_file(&block)
    io = FakeIO.new('')
    File.stub(:open, true, io, &block)
    io.written
  end

  def with_registry(registry = {}, &block)
    Humidifier.stub(:registry, registry, &block)
  end
end
