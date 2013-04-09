module RR
  module WildcardMatchers
    class IsA
      attr_reader :klass

      def initialize(klass)
        @klass = klass
      end

      def wildcard_match?(other)
        self == other || other.is_a?(klass)
      end

      def ==(other)
        other.is_a?(self.class) && klass == other.klass
      end
      alias :eql? :==

      def inspect
        "is_a(#{klass})"
      end
    end
  end
end
