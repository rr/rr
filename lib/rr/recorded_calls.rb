module RR
  class RecordedCalls
    include RR::Space::Reader

    def initialize(recorded_calls=[])
      @recorded_calls = recorded_calls
      @ordered_index = 0
    end

    attr_reader :recorded_calls

    def [](index)
      @recorded_calls[index]
    end

    def clear
      self.ordered_index = 0
      recorded_calls.clear
    end

    def add(subject, method_name, arguments, keyword_arguments, block)
      recorded_calls << RecordedCall.new(subject,
                                         method_name,
                                         arguments,
                                         keyword_arguments,
                                         block)
    end

    def any?(&block)
      recorded_calls.any?(&block)
    end

    def ==(other)
      recorded_calls == other.recorded_calls
    end

    def match_error(spy_verification)
      double_injection_exists_error(spy_verification) || begin
        if spy_verification.ordered?
          ordered_match_error(spy_verification)
        else
          unordered_match_error(spy_verification)
        end
      end
    end

  protected
    attr_accessor :ordered_index

    def double_injection_exists_error(spy_verification)
      unless Injections::DoubleInjection.exists_by_subject?(spy_verification.subject, spy_verification.method_name)
        RR::Errors.build_error(RR::Errors::SpyVerificationErrors::DoubleInjectionNotFoundError,
          "A Double Injection for the subject and method call:\n" <<
          "#{spy_verification.subject_inspect}\n" <<
          "#{spy_verification.method_name}\ndoes not exist in:\n" <<
          "\t#{recorded_calls.map {|call| call.inspect }.join("\n\t")}"
        )
      end
    end

    def ordered_match_error(spy_verification)
      memoized_matching_recorded_calls = matching_recorded_calls(spy_verification)

      if memoized_matching_recorded_calls.last
        self.ordered_index = recorded_calls.index(memoized_matching_recorded_calls.last)
      end
      (0..memoized_matching_recorded_calls.size).to_a.any? do |i|
        spy_verification.times_matcher.matches?(i)
      end ? nil : invocation_count_error(spy_verification, memoized_matching_recorded_calls)
    end

    def unordered_match_error(spy_verification)
      memoized_matching_recorded_calls = matching_recorded_calls(spy_verification)

      spy_verification.times_matcher.matches?(
        memoized_matching_recorded_calls.size
      ) ? nil : invocation_count_error(spy_verification, memoized_matching_recorded_calls)
    end

    def matching_recorded_calls(spy_verification)
      recorded_calls[ordered_index..-1].
        select(&match_double_injection(spy_verification)).
        select(&match_argument_expectation(spy_verification))
    end

    def match_double_injection(spy_verification)
      lambda do |recorded_call|
        recorded_call.subject == spy_verification.subject &&
          recorded_call.method_name == spy_verification.method_name
      end
    end

    def match_argument_expectation(spy_verification)
      lambda do |recorded_call|
        expectation = spy_verification.argument_expectation
        arguments = recorded_call.arguments
        keyword_arguments = recorded_call.keyword_arguments
        expectation.exact_match?(arguments, keyword_arguments) ||
          expectation.wildcard_match?(arguments, keyword_arguments)
      end
    end

    def invocation_count_error(spy_verification, matching_recorded_calls)
      method_name = spy_verification.method_name
      arguments = spy_verification.argument_expectation.expected_arguments
      keyword_arguments = spy_verification.argument_expectation.expected_keyword_arguments
      RR::Errors.build_error(RR::Errors::SpyVerificationErrors::InvocationCountError,
        "On subject #{spy_verification.subject.inspect}\n" <<
        "Expected #{Double.formatted_name(method_name, arguments, keyword_arguments)}\n" <<
        "to be called #{spy_verification.times_matcher.expected_times_message},\n" <<
        "but was called #{matching_recorded_calls.size} times.\n" <<
        "All of the method calls related to Doubles are:\n" <<
        "\t#{recorded_calls.map {|call| call.inspect}.join("\n\t")}"
      )
    end
  end
end
