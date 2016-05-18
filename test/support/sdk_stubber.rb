module SdkStubber
  module AwsDouble
    module CloudFormation
      module Errors
        class ValidationError < StandardError; end
      end

      class Client
        def initialize(*)
        end

        def method_missing(method, *args, &block)
          SdkStubber.call(method, args, &block)
        end
      end

      class Stack
        def initialize(*)
        end

        def method_missing(method, *args)
          SdkStubber.call(method, args)
        end
      end
    end
  end

  class Payload
    attr_accessor :id, :identifier, :max_wait, :name, :options, :to_cf

    def initialize(opts = {})
      self.identifier = opts[:identifier]
      self.max_wait   = opts[:max_wait]
      self.name       = opts[:name]
      self.options    = opts.fetch(:options, {})
      self.to_cf      = opts[:to_cf]
    end
  end

  class Stub
    attr_accessor :struct

    def initialize(struct)
      self.struct = struct || {}
    end

    def method_missing(method, *)
      struct.key?(method) ? struct[method] : super
    end

    def key?(key)
      struct.key?(key)
    end
  end

  class Tracker
    attr_accessor :stubs

    def initialize
      reset
    end

    def call(method, args)
      found = find_stub(method, args)
      stubs[method].delete(found)
      stubs.delete(method) if stubs[method].empty?

      yield AwsDouble::CloudFormation::Client.new if block_given?
      found[1]
    end

    def expect(method, args, return_value = nil)
      stubs[method] ||= []
      stubs[method] << [args, return_value]
    end

    def verify
      return if stubs.empty?

      message = "Expected calls to:\n"
      stubs.map do |method, method_stubs|
        message << "  #{method} with args:\n"
        message << method_stubs.map { |(stub_args, _)| "    #{stub_args.inspect}" }.join("\n")
        message << "\n"
      end

      reset
      raise message
    end

    private

    def find_stub(method, args)
      raise "Unexpected call to #{method}" unless stubs.key?(method)
      found = stubs[method].detect { |(stub_args, _)| stub_args == args }
      raise "Unexpected call to #{method} with args #{args}" if found.nil?
      found
    end

    def reset
      self.stubs = {}
    end
  end

  class << self
    extend Forwardable
    def_delegators :tracker, :call, :expect, :verify

    def tracker
      @tracker ||= Tracker.new
    end
  end
end
