shared_context 'tests for a double definition creator method that supports stubbing' do
  include DoubleDefinitionCreatorHelpers

  it_behaves_like 'defining a method double that sets the implementation of that method'

  context 'defining a method double with an argument expectation' do
    context 'by passing arguments to the double definition directly' do
      include_context 'using 1 of 2 ways to define a method double with an argument expectation without any qualifiers'

      def define_double_with_argument_expectation(double_creator, method_name, *args)
        double_creator.__send__(method_name, *args)
      end
    end

    # https://github.com/rr/rr/issues/23
    unless supports_strong?
      context 'by using #with and arguments' do
        include_context 'using 1 of 2 ways to define a method double with an argument expectation without any qualifiers'

        def define_double_with_argument_expectation(double_creator, method_name, *args)
          double_creator.__send__(method_name).with(*args)
        end
      end
    end
  end

  it_behaves_like 'defining a method double qualified with #yields'
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
      expect(object == :whatever).to eq 'value'
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
      parent_class.some_method
      expect(child_class.some_method).to eq 'existing value'
    end
  end
end
