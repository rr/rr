require File.expand_path('../../spec_helper', __FILE__)

permutations =
  %w(stub strong).permutation.map { |parts| parts.join('.') } +
  %w(strong)

permutations.each do |permutation|
  describe permutation, is_strong: true do
    include_context 'stub + strong'

    define_method(:double_definition_creator_for) do |object, &block|
      eval(permutation + '(object, &block)')
    end
  end
end
