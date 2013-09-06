shared_examples_for 'defining method doubles using the block form of the double definition creator' do
  include DoubleDefinitionCreatorHelpers

  it "allows multiple methods to be doubled" do
    object = build_object_with_possible_methods(
      some_method: -> { 'existing value 1' },
      another_method: -> { 'existing value 2' }
    ) do |subject|
      double_definition_creator_for(subject) do
        some_method { 'value 1' }
        another_method { 'value 2' }
      end
    end
    expect_call_to_return_or_raise_times_called_error('value 1', object, :some_method)
    expect_call_to_return_or_raise_times_called_error('value 2', object, :another_method)
  end

  it "yields rather than using instance_eval if a block argument is given" do
    object = build_object_with_possible_methods(
      some_method: -> { 'existing value 1' },
      another_method: -> { 'existing value 2' }
    ) do |subject|
      double_definition_creator_for(subject) do |double_creator|
        double_creator.some_method { 'value 1' }
        double_creator.another_method { 'value 2' }
      end
    end
    expect_call_to_return_or_raise_times_called_error('value 1', object, :some_method)
    expect_call_to_return_or_raise_times_called_error('value 2', object, :another_method)
  end
end
