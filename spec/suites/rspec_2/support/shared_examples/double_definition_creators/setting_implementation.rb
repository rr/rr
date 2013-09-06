shared_examples_for 'defining a method double that sets the implementation of that method' do
  include DoubleDefinitionCreatorHelpers

  it "works when not given a block" do
    expect_that_double_can_be_defined_without_block
  end

  context 'by giving a block' do
    it "replaces the implementation with the block" do
      expect_that_double_sets_implementation do |double_creator, method_name, block|
        double_creator.__send__(method_name, &block)
      end
    end

    it "resets the double correctly" do
      expect_that_double_sets_implementation_and_resets do |double_creator, method_name, block|
        double_creator.__send__(method_name, &block)
      end
    end
  end

  context 'by using #returns' do
    context 'with a block' do
      it "replaces the implementation with the block" do
        expect_that_double_sets_implementation do |double_creator, method_name, block|
          double_creator.__send__(method_name).returns(&block)
        end
      end

      it "resets the double correctly" do
        expect_that_double_sets_implementation_and_resets do |double_creator, method_name, block|
          double_creator.__send__(method_name).returns(&block)
        end
      end
    end

    context 'with a straight argument' do
      it "makes the method return the argument" do
        expect_that_double_sets_value do |double_creator, method_name, value|
          double_creator.__send__(method_name).returns(value)
        end
      end

      it "resets the double correctly" do
        expect_that_double_sets_value_and_resets do |double, method_name, value|
          double_creator.__send__(method_name).returns(value)
        end
      end
    end
  end
end
