class TestStub < Test::Unit::TestCase
  test "ordered arguments + keyword arguments" do
    object = Object.new
    stub(object).hello("Alice", "Bob", comment: "Wow!").once
    object.hello("Alice", "Bob", comment: "Wow!")
  end
end
