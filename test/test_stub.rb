class TestStub < Test::Unit::TestCase
  sub_test_case("ordered arguments + keyword arguments") do
    test("without implementation") do
      object = Object.new
      stub(object).hello("Alice", "Bob", comment: "Wow!").once
      object.hello("Alice", "Bob", comment: "Wow!")
    end

    test("with implementation") do
      klass = Class.new do
        def hello(from, to, comment:)
        end
      end
      object = klass.new
      stub(object).hello("Alice", "Bob", comment: "Wow!").once
      object.hello("Alice", "Bob", comment: "Wow!")
    end
  end

  sub_test_case("keyword arguments") do
    test("without implementation") do
      object = Object.new
      stub(object).hello(to: "Alice").once
      object.hello(to: "Alice")
    end

    test("with implementation") do
      klass = Class.new do
        def hello(to:)
        end
      end
      object = klass.new
      stub(object).hello(to: "Alice").once
      object.hello(to: "Alice")
    end

    test("assert_received") do
      object = Object.new
      stub(object).hello(to: "Alice").once
      object.hello(to: "Alice")
      assert_received(object) do |target|
        target.hello(to: "Alice")
      end
    end
  end
end
