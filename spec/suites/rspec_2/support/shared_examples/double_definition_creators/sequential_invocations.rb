shared_examples_for 'defining a method double for sequential invocations of that method using #ordered/#then' do
  include DoubleDefinitionCreatorHelpers

  it "works" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      double_creator.some_method { 'value 1' }.twice.ordered
      double_creator.some_method { 'value 2' }.once.ordered
    end

    expect(object.some_method).to eq 'value 1'
    expect(object.some_method).to eq 'value 1'
    expect(object.some_method).to eq 'value 2'
  end

  it "works when using #then instead of #ordered" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject|
      double_definition_creator_for(subject).
        some_method { 'value 1' }.once.then.
        some_method { 'value 2' }.once
    end

    expect(object.some_method).to eq 'value 1'
    expect(object.some_method).to eq 'value 2'
  end
end
