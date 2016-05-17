module TestHelpers
  StackDouble = Struct.new(:name, :to_cf) do
    attr_accessor :id
    alias_method :identifier, :name
  end

  private

  def payload_double(name: 'test-stack', to_cf: true)
    Humidifier::SdkPayload.new(StackDouble.new(name, to_cf), {})
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
end
