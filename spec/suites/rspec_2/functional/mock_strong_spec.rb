require File.expand_path('../../spec_helper', __FILE__)

permutations =
  %w(mock strong).permutation.map { |parts| parts.join('.') }

permutations.each do |permutation|
  describe permutation, is_mock: true, is_strong: true do
    include_context 'mock + strong'

    define_method(:double_definition_creator_for) do |object, &block|
      eval(permutation + '(object, &block)')
    end
  end
end
