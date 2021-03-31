module RR
  # RR::Double is the use case for a method call.
  # It has the ArgumentEqualityExpectation, TimesCalledExpectation,
  # and the implementation.
  class Double
    extend(Module.new do
      def formatted_name(method_name, args, kwargs)
        formatted_arguments =
          args.collect {|arg| arg.inspect} +
          kwargs.collect {|keyword, value| "#{keyword}: #{value.inspect}"}
        formatted_errors = formatted_arguments.join(', ')
        "#{method_name}(#{formatted_errors})"
      end

      def list_message_part(doubles)
        doubles.collect do |double|
          name = formatted_name(double.method_name,
                                double.expected_arguments,
                                double.expected_keyword_arguments)
          "- #{name}"
        end.join("\n")
      end
    end)

    attr_reader :times_called, :double_injection, :definition, :times_called_expectation

    include Space::Reader

    def initialize(double_injection, definition)
      @double_injection = double_injection
      @definition = definition
      @times_called = 0
      @times_called_expectation = Expectations::TimesCalledExpectation.new(self)
      definition.double = self
      verify_method_signature if definition.verify_method_signature?
      double_injection.register_double self
    end

    # Double#exact_match? returns true when the passed in arguments
    # exactly match the ArgumentEqualityExpectation arguments.
    def exact_match?(arguments, keyword_arguments)
      definition.exact_match?(arguments, keyword_arguments)
    end

    # Double#wildcard_match? returns true when the passed in arguments
    # wildcard match the ArgumentEqualityExpectation arguments.
    def wildcard_match?(arguments, keyword_arguments)
      definition.wildcard_match?(arguments, keyword_arguments)
    end

    # Double#attempt? returns true when the
    # TimesCalledExpectation is satisfied.
    def attempt?
      verify_times_matcher_is_set
      times_called_expectation.attempt?
    end

    # Double#verify verifies the the TimesCalledExpectation
    # is satisfied for this double. A TimesCalledError
    # is raised if the TimesCalledExpectation is not met.
    def verify
      verify_times_matcher_is_set
      times_called_expectation.verify!
      true
    end

    def terminal?
      verify_times_matcher_is_set
      times_called_expectation.terminal?
    end

    # The method name that this Double is attatched to
    def method_name
      double_injection.method_name
    end

    # The Arguments that this Double expects
    def expected_arguments
      verify_argument_expectation_is_set
      argument_expectation.expected_arguments
    end

    # The keyword arguments that this Double expects
    def expected_keyword_arguments
      verify_argument_expectation_is_set
      argument_expectation.expected_keyword_arguments
    end

    # The TimesCalledMatcher for the TimesCalledExpectation
    def times_matcher
      definition.times_matcher
    end

    def formatted_name
      self.class.formatted_name(method_name,
                                expected_arguments,
                                expected_keyword_arguments)
    end

    def method_call(args, kwargs)
      if verbose?
        puts Double.formatted_name(method_name, args, kwargs)
      end
      times_called_expectation.attempt if definition.times_matcher
      space.verify_ordered_double(self) if ordered?
    end

    def implementation_is_original_method?
      definition.implementation_is_original_method?
    end

  protected
    def ordered?
      definition.ordered?
    end

    def verbose?
      definition.verbose?
    end

    def verify_times_matcher_is_set
      unless definition.times_matcher
        raise RR::Errors.build_error(:DoubleDefinitionError, "#definition.times_matcher is not set")
      end
    end

    def verify_argument_expectation_is_set
      unless definition.argument_expectation
        raise RR::Errors.build_error(:DoubleDefinitionError, "#definition.argument_expectation is not set")
      end
    end

    def verify_method_signature
      unless double_injection.subject_has_original_method?
        raise RR::Errors.build_error(:SubjectDoesNotImplementMethodError)
      end
      raise RR::Errors.build_error(:SubjectHasDifferentArityError) unless arity_matches?
    end

    def subject_arity
      double_injection.original_method.arity
    end

    def subject_accepts_only_varargs?
      subject_arity == -1
    end

    def subject_accepts_varargs?
      subject_arity < 0
    end

    def arity_matches?
      return true if subject_accepts_only_varargs?
      if subject_accepts_varargs?
        return ((subject_arity * -1) - 1) <= args.size
      else
        return subject_arity == args.size
      end
    end

    def args
      definition.argument_expectation.expected_arguments
    end

    def kwargs
      definition.argument_expectation.expected_keyword_arguments
    end

    def argument_expectation
      definition.argument_expectation
    end
  end
end
