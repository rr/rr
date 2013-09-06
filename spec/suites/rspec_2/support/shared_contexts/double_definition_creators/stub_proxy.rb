shared_context 'stub + proxy' do
  include ProxyDefinitionCreatorHelpers

  context 'against instance methods', method_type: :instance do
    include_context 'tests for a double definition creator method that supports stubbing'
  end

  context 'against class methods', method_type: :class do
    include_context 'tests for a double definition creator method that supports stubbing'
  end
end
