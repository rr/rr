class TestMockProxy < Test::Unit::TestCase
  test "keyword arguments" do
    object = Object.new
    def object.hello(name: "Alice")
      "Hello #{name}!"
    end
    mock.proxy(object).hello(name: "Bob").once
    object.hello(name: "Bob")
  end

  test "ordered arguments + keyword arguments" do
    object = Object.new
    def object.hello(name, comment: "Yay!")
      "Hello #{name}! #{comment}."
    end
    mock.proxy(object).hello("Bob", comment: "Wow!").once
    object.hello("Bob", comment: "Wow!")
  end
end
