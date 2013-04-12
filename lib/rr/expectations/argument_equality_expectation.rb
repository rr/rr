module RR
  module Expectations
    class ArgumentEqualityExpectation #:nodoc:
      def self.recursive_safe_eq(arg1, arg2)
        if arg1.respond_to?(:'__rr__original_==')
          arg1.__send__(:'__rr__original_==', arg2)
        else
          arg1 == arg2
        end
      end

      attr_reader :expected_arguments

      def initialize(*expected_arguments)
        @expected_arguments = expected_arguments
      end

      def exact_match?(*arguments)
        return false unless arguments.length == expected_arguments.length
        arguments.each_with_index do |arg, index|
          return false unless self.class.recursive_safe_eq(expected_arguments[index], arg)
        end
        true
      end

      def wildcard_match?(*arguments)
        return false unless arguments.length == expected_arguments.length
        arguments.each_with_index do |arg, index|
          expected_argument = expected_arguments[index]
          if expected_argument.respond_to?(:wildcard_match?)
            return false unless expected_argument.wildcard_match?(arg)
          else
            return false unless self.class.recursive_safe_eq(expected_argument, arg)
          end
        end
        true
      end

      def ==(other)
        expected_arguments == other.expected_arguments
      end
    end
  end
end
