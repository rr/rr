class TestMockProxy < Test::Unit::TestCase
  test "keyword arguments" do
    object = Object.new
    def object.hello(name: "Alice")
      "Hello #{name}!"
    end
    mock.proxy(object).hello(name: "Bob").once
    object.hello(name: "Bob")
  end
end
