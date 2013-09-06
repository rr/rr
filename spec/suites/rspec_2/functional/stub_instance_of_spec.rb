require File.expand_path('../../spec_helper', __FILE__)

permutations =
  %w(stub instance_of).permutation.map { |parts| parts.join('.') } +
  %w(instance_of)

permutations.each do |permutation|
  describe permutation, is_instance_of: true do
    include_context 'stub + instance_of'

    define_method(:double_definition_creator_for) do |object, &block|
      eval(permutation + '(object, &block)')
    end
  end
end
