module RR
  module WildcardMatchers
    class HashIncluding
      attr_reader :expected_hash

      def initialize(expected_hash)
        @expected_hash = expected_hash.dup
      end

      def wildcard_match?(other)
        self == other || (
          other.is_a?(Hash) &&
          expected_hash.all? { |k, v|
            other.key?(k) && other[k] == expected_hash[k]
          }
        )
      end

      def ==(other)
        other.is_a?(self.class) &&
        other.expected_hash == self.expected_hash
      end
      alias :eql? :==

      def inspect
        "hash_including(#{expected_hash.inspect})"
      end
    end
  end
end
