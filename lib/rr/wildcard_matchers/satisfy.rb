module RR
  module WildcardMatchers
    class Satisfy
      attr_reader :expectation_proc

      def initialize(expectation_proc)
        @expectation_proc = expectation_proc
      end

      def wildcard_match?(other)
        self == other ||
        !!expectation_proc.call(other)
      end

      def ==(other)
        other.is_a?(self.class) &&
        other.expectation_proc.equal?(self.expectation_proc)
      end
      alias :eql? :==

      def inspect
        "satisfy { ... }"
      end
    end
  end
end
