module RR
  module WildcardMatchers
    class Boolean
      def wildcard_match?(other)
        self == other ||
        other.equal?(true) || other.equal?(false)
      end

      def ==(other)
        other.is_a?(self.class)
      end
      alias :eql? :==

      def inspect
        'boolean'
      end
    end
  end
end
