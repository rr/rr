shared_context 'mock + proxy' do
  include ProxyDefinitionCreatorHelpers

  context 'against instance methods', method_type: :instance do
    include_context 'tests for a double definition creator method that supports mocking'
  end

  context 'against class methods', method_type: :class do
    include_context 'tests for a double definition creator method that supports mocking'
  end
end
