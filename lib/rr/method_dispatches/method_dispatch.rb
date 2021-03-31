module RR
  module MethodDispatches
    class MethodDispatch < BaseMethodDispatch
      attr_reader :double_injection, :subject

      def initialize(double_injection, subject, args, kwargs, block)
        @double_injection = double_injection
        @subject = subject
        @args = args
        @kwargs = kwargs
        @block = block
        @double = find_double_to_attempt
      end

      def call
        space.record_call(subject, method_name, args, kwargs, block)
        if double
          double.method_call(args, kwargs)
          call_yields
          return_value_1 = call_implementation
          return_value_2 = extract_subject_from_return_value(return_value_1)
          if after_call_proc
            extract_subject_from_return_value(after_call_proc.call(return_value_2))
          else
            return_value_2
          end
        else
          double_not_found_error
        end
      end

      def call_original_method
        if subject_has_original_method?
          if KeywordArguments.fully_supported?
            subject.__send__(original_method_alias_name, *args, **kwargs, &block)
          else
            subject.__send__(original_method_alias_name, *args, &block)
          end
        elsif subject_has_original_method_missing?
          call_original_method_missing
        else
          if KeywordArguments.fully_supported?
            subject.__send__(:method_missing, method_name, *args, **kwargs, &block)
          else
            subject.__send__(:method_missing, method_name, *args, &block)
          end
        end
      end

    protected
      def call_implementation
        if implementation_is_original_method?
          call_original_method
        else
          if implementation
            if KeywordArguments.fully_supported?
              implementation.call(*args, **kwargs, &block)
            else
              implementation.call(*args, &block)
            end
          else
            nil
          end
        end
      end

      def_delegators :definition, :implementation
      def_delegators :double_injection, :subject_has_original_method?, :subject_has_original_method_missing?, :method_name, :original_method_alias_name
    end
  end
end
