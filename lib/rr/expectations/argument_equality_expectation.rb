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
      attr_reader :expected_keyword_arguments

      def initialize(expected_arguments,
                     expected_keyword_arguments)
        @expected_arguments = expected_arguments
        @expected_keyword_arguments = expected_keyword_arguments
      end

      def exact_match?(arguments, keyword_arguments)
        return false unless arguments.length == expected_arguments.length
        arguments.each_with_index do |arg, index|
          expected_arg = expected_arguments[index]
          return false unless self.class.recursive_safe_eq(expected_arg, arg)
        end
        keywords = keyword_arguments.keys
        expected_keywords = expected_keyword_arguments.keys
        unless keywords.length == expected_keywords.length
          return false
        end
        keywords.each do |keyword|
          keyword_argument = keyword_arguments[keyword]
          expected_keyword_argument = expected_keyword_arguments[keyword]
          unless self.class.recursive_safe_eq(expected_keyword_argument,
                                              keyword_argument)
            return false
          end
        end
        true
      end

      def wildcard_match?(arguments, keyword_arguments)
        return false unless arguments.length == expected_arguments.length
        arguments.each_with_index do |arg, index|
          expected_argument = expected_arguments[index]
          if expected_argument.respond_to?(:wildcard_match?)
            return false unless expected_argument.wildcard_match?(arg)
          else
            return false unless self.class.recursive_safe_eq(expected_argument, arg)
          end
        end
        keywords = keyword_arguments.keys
        expected_keywords = expected_keyword_arguments.keys
        unless keywords.length == expected_keywords.length
          return false
        end
        keywords.each do |keyword|
          keyword_argument = keyword_arguments[keyword]
          expected_keyword_argument = expected_keyword_arguments[keyword]
          if expected_keyword_argument.respond_to?(:wildcard_match?)
            unless expected_keyword_argument.wildcard_match?(keyword_argument)
              return false
            end
          else
            unless self.class.recursive_safe_eq(expected_keyword_argument,
                                                keyword_argument)
              return false
            end
          end
        end
        true
      end

      def ==(other)
        other.is_a?(self.class) and
          expected_arguments == other.expected_arguments and
          expected_keyword_arguments == other.expected_keyword_arguments
      end
    end
  end
end
