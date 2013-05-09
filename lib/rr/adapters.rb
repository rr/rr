module RR
  module Adapters
    class << self
      def build(adapter_const_name)
        const_get(adapter_const_name).new
      end
    end
  end
end
