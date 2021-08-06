module RR
  class SpyVerification
    def initialize(subject, method_name, args, kwargs)
      @subject = subject
      @method_name = method_name.to_sym
      set_argument_expectation_for_args(args, kwargs)
      @ordered = false
      once
    end

    attr_reader :argument_expectation, :method_name, :times_matcher
    attr_accessor :subject

    include RR::DoubleDefinitions::DoubleDefinition::TimesDefinitionConstructionMethods
    include RR::DoubleDefinitions::DoubleDefinition::ArgumentDefinitionConstructionMethods

    def ordered
      @ordered = true
      self
    end

    def ordered?
      @ordered
    end

    def call
      (error = RR.recorded_calls.match_error(self)) && raise(error)
    end

    def to_proc
      lambda do
        call
      end
    end

    def subject_inspect
      if subject.respond_to?(:__rr__original_inspect, true)
        subject.__rr__original_inspect
      else
        subject.inspect
      end
    end

  protected
    attr_writer :times_matcher

    def set_argument_expectation_for_args(args, kwargs)
      if args.empty? and kwargs.empty?
        # with_no_args and with actually set @argument_expectation
        with_no_args
      else
        if KeywordArguments.fully_supported?
          with(*args, **kwargs)
        else
          with(*args)
        end
      end
    end

    def install_method_callback(return_value_block)
      # Do nothing. This is to support DefinitionConstructionMethods
    end
  end
end
