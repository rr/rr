shared_examples_for 'comparing the arity between the method and double definition' do
  it "succeeds if both have no arity" do
    object = build_object_with_methods(some_method: -> {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      double_creator.some_method
    end
    object.some_method
  end

  it "fails if the former has no arity and the latter does" do
    build_object_with_methods(some_method: -> {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      expect { double_creator.some_method(1) }.to \
        raise_error(RR::Errors::SubjectHasDifferentArityError)
    end
  end

  it "fails if the former has arity but the latter doesn't" do
    build_object_with_methods(some_method: ->(arg) {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      expect { double_creator.some_method }.to \
        raise_error(RR::Errors::SubjectHasDifferentArityError)
    end
  end

  it "succeeds if both have a finite number of arguments" do
    object = build_object_with_methods(some_method: ->(arg) {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      double_creator.some_method(1)
    end
    object.some_method(1)
  end

  it "succeeds if both have a variable number of arguments" do
    object = build_object_with_methods(some_method: ->(*args) {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      double_creator.some_method(1)
      double_creator.some_method(1, 2, 3)
      double_creator.some_method(1, 2)
    end
    object.some_method(1)
    object.some_method(1, 2)
    object.some_method(1, 2, 3)
  end

  it "succeeds if both have finite and variable number of arguments" do
    object = build_object_with_methods(some_method: ->(arg1, arg2, *rest) {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      double_creator.some_method(1, 2)
      double_creator.some_method(1, 2, 3)
    end
    object.some_method(1, 2)
    object.some_method(1, 2, 3)
  end

  it "fails if the finite arguments are not matched before the variable arguments" do
    build_object_with_methods(some_method: ->(arg1, arg2, *rest) {}) do |subject|
      double_creator = double_definition_creator_for(subject)
      expect { double_creator.some_method(1) }.to \
        raise_error(RR::Errors::SubjectHasDifferentArityError)
    end
  end
end
