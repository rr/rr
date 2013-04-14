module RR
  module Expectations
    class TimesCalledExpectation #:nodoc:
      attr_reader :double, :times_called

      def initialize(double)
        @double = double
        @times_called = 0
        @verify_backtrace = caller[1..-1]
      end

      def attempt?
        times_matcher.attempt?(@times_called)
      end

      def attempt
        @times_called += 1
        verify_input_error unless times_matcher.possible_match?(@times_called)
        return
      end

      def verify
        return false unless times_matcher.is_a?(TimesCalledMatchers::TimesCalledMatcher)
        return times_matcher.matches?(@times_called)
      end

      def verify!
        unless verify
          raise RR::Errors.build_error(:TimesCalledError, error_message, @verify_backtrace)
        end
      end

      def terminal?
        times_matcher.terminal?
      end

    protected
      def times_matcher
        double.definition.times_matcher
      end

      def verify_input_error
        raise RR::Errors.build_error(:TimesCalledError, error_message)
      end

      def error_message
        "#{double.formatted_name}\n#{times_matcher.error_message(@times_called)}"
      end
    end
  end
end
