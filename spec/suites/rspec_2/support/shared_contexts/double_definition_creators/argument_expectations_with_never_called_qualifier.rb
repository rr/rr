shared_context 'using 1 of 2 ways to define a mock with an argument expectation with a never-called qualifier' do
  include DoubleDefinitionCreatorHelpers

  it "works as long as the invocation never occurs" do
    build_object_with_possible_methods(some_method: lambda {|arg| }) do |subject|
      double_creator = double_definition_creator_for(subject)
      define_double_with_argument_expectation(double_creator, :some_method, 1).never
    end
  end

  it "works as long as the invocation never occurs even if other invocations occur" do
    object = build_object_with_possible_methods(some_method: lambda {|arg| }) do |subject|
      double_creator = double_definition_creator_for(subject)
      define_double_with_argument_expectation(double_creator, :some_method, 1).never
    end
    stub(object).some_method.with_any_args
    object.some_method(2)
  end

  specify "TimesCalledError is raised as soon as the invocation occurs" do
    object = build_object_with_possible_methods(some_method: lambda {|arg| }) do |subject|
      double_creator = double_definition_creator_for(subject)
      define_double_with_argument_expectation(double_creator, :some_method, 1).never
    end
    expect { object.some_method(1) }.to raise_error(RR::Errors::TimesCalledError)
    RR.reset
  end

  specify "nothing happens upon being reset" do
    object = build_object_with_possible_methods(some_method: lambda {|arg| }) do |subject|
      double_creator = double_definition_creator_for(subject)
      define_double_with_argument_expectation(double_creator, :some_method, 1).never
    end
    RR.reset
    expect {
      call_possible_method_on(object, :some_method, 1)
    }.not_to raise_error
  end
end
