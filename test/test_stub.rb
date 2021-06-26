class TestStub < Test::Unit::TestCase
  test "ordered arguments + keyword arguments" do
    object = Object.new
    stub(object).hello("Alice", "Bob", comment: "Wow!").once
    object.hello("Alice", "Bob", comment: "Wow!")
  end

  test "keyword arguments expectation" do
    object = Object.new
    stub(object).call(1, b: 2).once
    object.call(1, b: 2)
  end

  test "keyword arguments expectation with implementation" do
    klass = Class.new do
      def call(a, b:); end
    end
    object = klass.new
    stub(object).call(1, b: 2).once
    object.call(1, b: 2)
  end
end
