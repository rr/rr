module MockDefinitionCreatorHelpers
  include DoubleDefinitionCreatorHelpers

  def expect_that_double_can_be_defined_without_block
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('value')
    expect(return_value).to eq nil
  end

  def expect_that_double_sets_implementation(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('old value', -> { 'new value' }, &block)
    expect(return_value).to eq 'new value'
  end

  def expect_that_double_sets_implementation_and_resets(&block)
    object, method_name, return_value =
      build_object_with_doubled_method_which_is_reset_and_called('old value', -> { 'new value' }, &block)

    if methods_being_doubled_exist_already?
      # This doesn't work quite yet - see btakita#44
      #expect(object).not_to respond_to(method_name)
    else
      expect(return_value).to eq 'old value'
    end
  end

  def expect_that_double_sets_value(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_called('old value', 'new value', &block)
    expect(return_value).to eq 'new value'
  end

  def expect_that_double_sets_value_and_resets(&block)
    _, _, return_value =
      build_object_with_doubled_method_which_is_reset_and_called('old value', 'new value', &block)

    if methods_being_doubled_exist_already?
      # This doesn't work quite yet - see btakita#44
      #expect(object).not_to respond_to(method_name)
    else
      expect(return_value).to eq 'old value'
    end
  end
end
