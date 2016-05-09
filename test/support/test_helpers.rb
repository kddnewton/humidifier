module TestHelpers
  StackDouble = Struct.new(:name, :to_cf)

  private

  def stack_double(to_cf)
    StackDouble.new('test-stack', to_cf)
  end

  def suppress_warnings
    warn_level = $VERBOSE
    $VERBOSE = nil
    yield
    $VERBOSE = warn_level
  end

  def with_mocked_serializer(value)
    mock = Minitest::Mock.new
    mock.expect(:call, value, [value])

    Humidifier::Serializer.stub(:dump, mock) do
      yield value
    end
    mock.verify
  end

  def with_sdk_v1_loaded
    load 'support/aws_sdk_v1.rb'
    yield
    Object.send(:remove_const, :AWS)
  end

  def with_sdk_v2_loaded
    load 'support/aws_sdk_v2.rb'
    yield
    Object.send(:remove_const, :Aws)
  end
end
