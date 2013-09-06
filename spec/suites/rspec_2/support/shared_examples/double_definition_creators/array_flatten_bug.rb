# btakita/rr issue #44
shared_examples_for 'an object which has a method double wrapped in an array and flattened' do
  include DoubleDefinitionCreatorHelpers

  it "does not raise an error" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject|
      double_definition_creator_for(subject).some_method
    end
    # force RR to define method_missing
    call_method_rescuing_times_called_error(object, :some_method)
    expect([object].flatten).to eq [object]
  end

  it "honors a #to_ary that already exists" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject, object|
      (class << object; self; end).class_eval do
        def to_ary; []; end
      end
      double_definition_creator_for(subject).some_method
    end
    # force RR to define method_missing
    call_method_rescuing_times_called_error(object, :some_method)
    expect([object].flatten).to eq []
  end

  it "is reset correctly" do
    object = build_object_with_possible_methods(some_method: -> {}) do |subject|
      double_definition_creator_for(subject).some_method
    end
    # force RR to define method_missing
    call_method_rescuing_times_called_error(object, :some_method)
    RR.reset
    expect([object].flatten).to eq [object]
  end
end
