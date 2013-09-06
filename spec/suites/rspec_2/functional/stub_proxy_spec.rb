require File.expand_path('../../spec_helper', __FILE__)

permutations =
  %w(stub proxy).permutation.map { |parts| parts.join('.') } +
  %w(proxy)

permutations.each do |permutation|
  describe permutation, is_proxy: true do
    include_context 'stub + proxy'

    define_method(:double_definition_creator_for) do |object, &block|
      eval(permutation + '(object, &block)')
    end
  end

  def expect_that_double_can_be_defined_without_block
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('value', nil)
    expect(return_value).to eq 'value'
  end

  def expect_that_double_sets_implementation(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('value', ->(v) { v.upcase }, &block)
    expect(return_value).to eq 'VALUE'
  end

  def expect_that_double_sets_implementation_and_resets(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_reset_and_called('value', ->(v) { v.upcase }, &block)
    expect(return_value).to eq 'value'
  end

  def expect_that_double_sets_value(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('old value', 'new value', &block)
    expect(return_value).to eq 'new value'
  end

  def expect_that_double_sets_value_and_resets(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_reset_and_called('old value', 'new value', &block)
    expect(return_value).to eq 'old value'
  end
end
