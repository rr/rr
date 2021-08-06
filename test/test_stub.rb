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
end
