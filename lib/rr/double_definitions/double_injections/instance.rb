module RR
  module DoubleDefinitions
    module DoubleInjections
      class Instance
        extend(Module.new do
          include ::RR::DSL

          def call(double_method_name, *args, &definition_eval_block)
            double_definition_create = DoubleDefinitions::DoubleDefinitionCreate.new
            double_definition_create.send(double_method_name, *args, &definition_eval_block)
          end
        end)
      end
    end
  end
end
