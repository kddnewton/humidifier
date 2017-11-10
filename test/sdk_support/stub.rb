module SdkSupport
  class Stub
    attr_reader :struct

    def initialize(struct)
      @struct = struct || {}
    end

    def method_missing(method, *)
      struct.key?(method) ? struct[method] : super
    end

    def respond_to_missing?(method, *)
      struct.key?(method) || super
    end

    def key?(key)
      struct.key?(key)
    end
  end
end
