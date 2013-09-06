shared_context 'tests for a double definition creator method that supports dont_allow' do
  include DoubleDefinitionCreatorHelpers

  specify "TimesCalledError is raised as soon as the method is called" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject|
      dont_allow(subject).some_method
    end
    expect { object.some_method }.to raise_error(RR::Errors::TimesCalledError)
  end

  context 'defining a mock with an argument expectation with a times-called qualifier' do
    context 'by passing arguments to the double definition directly' do
      include_context 'using 1 of 2 ways to define a mock with an argument expectation with a times-called qualifier'

      def define_double_with_argument_expectation(double_creator, method_name, *args)
        double_creator.__send__(method_name, *args)
      end
    end

    # https://github.com/rr/rr/issues/23
    unless supports_strong?
      context 'by using #with and arguments' do
        include_context 'using 1 of 2 ways to define a mock with an argument expectation with a times-called qualifier'

        def define_double_with_argument_expectation(double_creator, method_name, *args)
          double_creator.__send__(method_name).with(*args)
        end
      end
    end
  end

  context 'defining a mock with an argument expectation with a never-called qualifier' do
    context 'by passing arguments to the double definition directly' do
      include_context 'using 1 of 2 ways to define a mock with an argument expectation with a never-called qualifier'

      def define_double_with_argument_expectation(double_creator, method_name, *args)
        double_creator.__send__(method_name, *args)
      end
    end

    # https://github.com/rr/rr/issues/23
    unless supports_strong?
      context 'by using #with and arguments' do
        include_context 'using 1 of 2 ways to define a mock with an argument expectation with a never-called qualifier'

        def define_double_with_argument_expectation(double_creator, method_name, *args)
          double_creator.__send__(method_name).with(*args)
        end
      end
    end
  end

  context 'defining a mock with an argument expectation without any qualifiers' do
    context 'by passing arguments to the double definition directly' do
      include_context 'using 1 of 2 ways to define a method double with an argument expectation without any qualifiers'

      specify "no error is raised if the method is never called at all" do
        build_object_with_possible_methods(some_method: -> {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
      end

      specify "a DoubleNotFoundError is raised if the method is called but not with the specified arguments" do
        object = build_object_with_possible_methods(some_method: -> {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { object.some_method }.to raise_error(RR::Errors::DoubleNotFoundError)
      end

      specify "a TimesCalledError is raised the moment the method is called with the specified arguments" do
        object = build_object_with_possible_methods(some_method: -> {}) do |subject|
          double_creator = double_definition_creator_for(subject)
          define_double_with_argument_expectation(double_creator, :some_method, 1)
        end
        expect { object.some_method(1) }.to raise_error(RR::Errors::TimesCalledError)
      end

      def define_double_with_argument_expectation(double_creator, method_name, *args)
        double_creator.__send__(method_name, *args)
      end
    end

    # https://github.com/rr/rr/issues/23
    unless supports_strong?
      context 'by using #with and arguments' do
        include_context 'using 1 of 2 ways to define a method double with an argument expectation without any qualifiers'

        specify "no error is raised if the method is never called at all" do
          build_object_with_possible_methods(some_method: -> {}) do |subject|
            double_creator = double_definition_creator_for(subject)
            define_double_with_argument_expectation(double_creator, :some_method, 1)
          end
        end

        specify "a DoubleNotFoundError is raised if the method is called but not with the specified arguments" do
          object = build_object_with_possible_methods(some_method: -> {}) do |subject|
            double_creator = double_definition_creator_for(subject)
            define_double_with_argument_expectation(double_creator, :some_method, 1)
          end
          expect { object.some_method }.to raise_error(RR::Errors::DoubleNotFoundError)
        end

        specify "a TimesCalledError is raised the moment the method is called with the specified arguments" do
          object = build_object_with_possible_methods(some_method: -> {}) do |subject|
            double_creator = double_definition_creator_for(subject)
            define_double_with_argument_expectation(double_creator, :some_method, 1)
          end
          expect { object.some_method(1) }.to raise_error(RR::Errors::TimesCalledError)
        end

        def define_double_with_argument_expectation(double_creator, method_name, *args)
          double_creator.__send__(method_name).with(*args)
        end
      end
    end
  end

  it_behaves_like 'defining method doubles using the block form of the double definition creator'
  it_behaves_like 'defining a method double for sequential invocations of that method using #ordered/#then'
  it_behaves_like 'an object which has a method double wrapped in an array and flattened'

  if supports_proxying? && !supports_instance_of?
    it_behaves_like 'defining a method double on an object which is a proxy for another object'
  end

  if methods_being_doubled_exist_already?
    it "lets you double operator methods as well as normal ones" do
      object = build_object do |subject|
        double_definition_creator_for(subject).==(anything) { 'value' }
      end
      expect_call_to_return_or_raise_times_called_error('value', object, :==, :whatever)
    end
  end

  if type_of_methods_being_tested == :class && methods_being_doubled_exist_already? && !supports_instance_of?
    it "in a parent class doesn't affect child classes" do
      parent_class = Class.new do
        def self.some_method; 'existing value'; end
      end
      child_class = Class.new(parent_class)
      double_creator = double_definition_creator_for(parent_class)
      double_creator.some_method { 'value' }
      expect(child_class.some_method).to eq 'existing value'
    end
  end
end
