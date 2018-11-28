# frozen_string_literal: true

module SdkSupport
  class Tracker
    attr_reader :stubs

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
      stubs.each do |method, method_stubs|
        message << "  #{method} with args:\n#{messages_from(method_stubs)}"
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

    def messages_from(method_stubs)
      method_stubs.map do |(stub_args, _)|
        "    #{stub_args.inspect}\n"
      end
    end

    def reset
      @stubs = {}
    end
  end
end
