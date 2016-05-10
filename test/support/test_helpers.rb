module TestHelpers
  module AwsDouble
    module CloudFormation
      module Errors
        class ValidationError < StandardError; end
      end

      class Client
        def initialize(*)
        end

        def method_missing(_, *, **kwargs)
          raise Errors::ValidationError, 'fake' if kwargs.any? { |_, value| !value }
        end

        def stacks
          CloudFormation.stacks
        end
      end

      class Stack
        def initialize(*)
        end

        def exists?
          CloudFormation.exists?
        end
      end

      class << self
        def exists?
          true
        end

        def stacks
          { 'test-stack' => self }
        end
      end
    end
  end

  StackDouble = Struct.new(:name, :to_cf)

  private

  def stack_double(name: 'test-stack', to_cf: true)
    StackDouble.new(name, to_cf)
  end

  def suppress_warnings
    warn_level = $VERBOSE
    $VERBOSE = nil
    yield
    $VERBOSE = warn_level
  end

  # sorry
  def with_faked_sdk_require
    filepath = File.expand_path(File.join('..', '..', 'aws-sdk.rb'), __FILE__)
    begin
      FileUtils.touch(filepath)
      yield
    ensure
      FileUtils.rm(filepath)
      $LOADED_FEATURES.reject! { |feature| feature.match(/aws-sdk/) }
    end
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
    Object.const_set(:AWS, AwsDouble)
    begin
      capture_io { yield }
    ensure
      Object.send(:remove_const, :AWS)
    end
  end

  def with_sdk_v2_loaded
    Object.const_set(:Aws, AwsDouble)
    begin
      capture_io { yield }
    ensure
      Object.send(:remove_const, :Aws)
    end
  end
end
