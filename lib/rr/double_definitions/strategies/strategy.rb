module RR
  module DoubleDefinitions
    module Strategies
      class Strategy
        attr_reader :double_definition_create
        attr_reader :definition
        attr_reader :method_name
        attr_reader :args
        attr_reader :kwargs
        attr_reader :handler

        include Space::Reader

        def initialize(double_definition_create)
          @double_definition_create = double_definition_create
        end

        def call(definition, method_name, args, kwargs, handler)
          @definition = definition
          @method_name = method_name
          @args = args
          @kwargs = kwargs
          @handler = handler
          do_call
        end

        def verify_subject(subject)
        end

      protected
        def do_call
          raise NotImplementedError
        end

        if KeywordArguments.fully_supported?
          def permissive_argument
            if args.empty? and kwargs.empty?
              definition.with_any_args
            else
              definition.with(*args, **kwargs)
            end
          end
        else
          def permissive_argument
            if args.empty?
              definition.with_any_args
            else
              definition.with(*args)
            end
          end
        end

        def reimplementation
          definition.returns(&handler)
        end

        def subject
          definition.subject
        end
      end
    end
  end
end
