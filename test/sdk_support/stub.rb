module SdkSupport
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
end
