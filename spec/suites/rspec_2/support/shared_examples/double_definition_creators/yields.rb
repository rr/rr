shared_examples_for 'defining a method double qualified with #yields' do
  include DoubleDefinitionCreatorHelpers

  context 'without arguments' do
    it "inserts a yield that passes no arguments" do
      object = build_object_with_possible_methods(some_method: -> {}) do |subject|
        double_definition_creator_for(subject).some_method.yields
      end
      x = 0
      object.some_method { x = 1 }
      expect(x).to eq 1
    end

    it "does not affect setting the implementation otherwise" do
      object = build_object_with_possible_methods(some_method: -> { 'existing value' }) do |subject|
        double_definition_creator_for(subject).some_method { 'value' }.yields
      end
      expect(object.some_method { }).to eq 'value'
    end

    it "also lets you set the implementation in preference to #returns" do
      object = build_object_with_possible_methods(some_method: -> { 'existing value' }) do |subject|
        double_definition_creator_for(subject).some_method.yields { 'value' }
      end
      expect(object.some_method { }).to eq 'value'
    end

    it "is reset correctly" do
      object = build_object_with_possible_methods(some_method: -> {}) do |subject|
        double_definition_creator_for(subject).some_method.yields
      end
      RR.reset
      x = 0
      if methods_being_doubled_exist_already?
        object.some_method { x = 1 }
        expect(x).to eq 0
      else
        expect_method_to_not_exist(object, :some_method)
      end
    end
  end

  context 'with arguments' do
    it "inserts a yield that passes those arguments" do
      object = build_object_with_possible_methods(some_method: -> {}) do |subject|
        double_definition_creator_for(subject).some_method.yields(1)
      end
      x = 0
      object.some_method {|a| x = a }
      expect(x).to eq 1
    end

    it "does not affect setting the implementation otherwise" do
      object = build_object_with_possible_methods(some_method: -> { 'existing value' }) do |subject|
        double_definition_creator_for(subject).some_method { 'value' }.yields(1)
      end
      expect(object.some_method { }).to eq 'value'
    end

    it "also lets you set the implementation in preference to #returns" do
      object = build_object_with_possible_methods(some_method: -> { 'existing value' }) do |subject|
        double_definition_creator_for(subject).some_method.yields(1) { 'value' }
      end
      expect(object.some_method { }).to eq 'value'
    end

    it "is reset correctly" do
      object = build_object_with_possible_methods(some_method: -> {}) do |subject|
        double_definition_creator_for(subject).some_method.yields(1)
      end
      RR.reset
      if methods_being_doubled_exist_already?
        x = 0
        object.some_method {|a| x = a }
        expect(x).to eq 0
      else
        expect_method_to_not_exist(object, :some_method)
      end
    end
  end
end
