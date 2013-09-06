require File.expand_path('../../spec_helper', __FILE__)

describe 'dont_allow', is_mock: true, is_dont_allow: true do
  include MockDefinitionCreatorHelpers

  context 'against instance methods', method_type: :instance do
    include_context 'tests for a double definition creator method that supports dont_allow'
  end

  context 'against class methods', method_type: :class do
    include_context 'tests for a double definition creator method that supports dont_allow'
  end

  def double_definition_creator_for(object, &block)
    dont_allow(object, &block)
  end
end
