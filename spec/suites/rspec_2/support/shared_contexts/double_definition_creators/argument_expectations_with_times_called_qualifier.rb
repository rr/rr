shared_context 'using 1 of 2 ways to define a mock with an argument expectation with a times-called qualifier' do
  include DoubleDefinitionCreatorHelpers

  context 'upon verification after the invocation occurs too few times' do
    specify "TimesCalledError is raised" do
      object = build_object_with_possible_methods(some_method: ->(arg) {}) do |subject|
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1).times(2)
      end
      call_possible_method_on(object, :some_method, 1)
      expect { RR.verify }.to raise_error(RR::Errors::TimesCalledError)
    end

    specify "nothing happens upon reset" do
      object = build_object_with_possible_methods(some_method: ->(arg) {}) do |subject|
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1).times(2)
      end
      RR.reset
      call_possible_method_on(object, :some_method, 1)
      expect { RR.verify }.not_to raise_error
    end
  end

  context 'the moment the invocation occurs one too many times' do
    specify "TimesCalledError is raised" do
      object = build_object_with_possible_methods(some_method: ->(arg) {}) do |subject|
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1).times(2)
      end
      call_possible_method_on(object, :some_method, 1)
      call_possible_method_on(object, :some_method, 1)
      expect { object.some_method(1) }.to raise_error(RR::Errors::TimesCalledError)
      RR.reset
    end

    specify "nothing happens upon reset" do
      object = build_object_with_possible_methods(some_method: ->(arg) {}) do |subject|
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1).times(2)
      end
      RR.reset
      call_possible_method_on(object, :some_method, 1)
      call_possible_method_on(object, :some_method, 1)
      expect {
        call_possible_method_on(object, :some_method, 1)
      }.not_to raise_error
    end
  end
end
