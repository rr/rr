shared_context 'using 1 of 2 ways to define a method double with an argument expectation without any qualifiers' do
  include DoubleDefinitionCreatorHelpers

  it "defines the double just for that specific invocation" do
    object = build_object_with_possible_methods(some_method: ->(*args) { 'value' }) do |subject|
      double_creator = double_definition_creator_for(subject)
      double = define_double_with_argument_expectation(double_creator, :some_method, 1)
      double.returns { 'bar' }
    end
    expect_call_to_return_or_raise_times_called_error('bar', object, :some_method, 1)
  end

  if supports_dont_allow?

    context 'upon verification after the invocation occurs too few times' do
      specify "no error is raised if the method is never called at all" do
        build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { RR.verify }.not_to raise_error
      end
    end

    context 'the moment an unknown invocation occurs' do
      specify "DoubleNotFoundError is raised" do
        object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { object.some_method }.to raise_error(RR::Errors::DoubleNotFoundError)
        RR.reset
      end

      it "is reset correctly" do
        object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        RR.reset
        expect {
          call_possible_method_on(object, :some_method)
        }.not_to raise_error
      end
    end

  elsif supports_mocking?

    context 'upon verification after the invocation occurs too few times' do
      specify "TimesCalledError is raised at the verify step if the method is never called at all" do
        build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { RR.verify }.to raise_error(RR::Errors::TimesCalledError)
      end

      specify "nothing happens upon being reset" do
        build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        RR.reset
        expect { RR.verify }.not_to raise_error
      end
    end

    context 'the moment an unknown invocation occurs' do
      specify "DoubleNotFoundError is raised" do
        object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { object.some_method }.to raise_error(RR::Errors::DoubleNotFoundError)
        RR.reset
      end

      specify "is reset correctly" do
        object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        RR.reset
        expect {
          call_possible_method_on(object, :some_method, 1)
        }.not_to raise_error
      end
    end

  else

    it "resets the double correctly" do
      object = build_object_with_possible_methods(some_method: ->(*args) { 'existing value' }) do |subject, object|
        expect_method_to_have_value_or_be_absent('existing value', object, :some_method, 1)
        double_creator = double_definition_creator_for(subject)
        double = define_double_with_argument_expectation(double_creator, :some_method, 1)
        double.returns { 'new value' }
      end
      RR.reset
      expect_method_to_have_value_or_be_absent('existing value', object, :some_method, 1)
    end

    it "raises DoubleNotFoundError the moment the method is called but not with the specified arguments" do
      object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1)
      end
      expect { object.some_method }.to raise_error(RR::Errors::DoubleNotFoundError)
      RR.reset
    end

  end

  unless supports_dont_allow?
    it "lets you define a catch-all double by defining a stub without arguments" do
      object = build_object_with_possible_methods(some_method: ->(*args) {}) do |subject|
        double_creator =
          if supports_instance_of?
            stub.instance_of(subject)
          else
            stub(subject)
          end
        double_creator.some_method
        double_creator = double_definition_creator_for(subject)
        define_double_with_argument_expectation(double_creator, :some_method, 1)
      end
      object.some_method(1)
      object.some_method(2)  # shouldn't raise an error
    end
  end
end
