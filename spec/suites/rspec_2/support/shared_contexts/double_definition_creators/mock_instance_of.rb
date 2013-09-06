shared_context 'mock + instance_of' do
  include MockDefinitionCreatorHelpers

  context 'where subject is a class', method_type: :class do
    include_context 'tests for a double definition creator method that supports mocking'

    it "lets you stub methods which are called in #initialize" do
      klass = Class.new do
        def initialize; method_run_in_initialize; end
        def method_run_in_initialize; end
      end
      method_double_called = false
      double_creator = double_definition_creator_for(klass)
      double_creator.method_run_in_initialize { method_double_called = true }
      klass.new
      expect(method_double_called).to eq true
    end
  end

  context 'where subject is an instance of a class', method_type: :instance do
    it "doesn't work" do
      double_creator = double_definition_creator_for(Object.new)
      expect { double_creator.some_method }.to raise_error(ArgumentError)
    end
  end
end
