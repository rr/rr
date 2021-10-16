class TestIntegerationMinitestActiveSupport < Test::Unit::TestCase
  setup do
    omit("Require Active Support") unless defined?(::ActiveSupport::TestCase)
  end

  test("verify") do
    test_class = Class.new(ActiveSupport::TestCase) do
      def test_verify
        object = Object.new
        mock(object).hello("Alice") do |name|
          "Hello #{name}!"
        end
      end
    end
    result = test_class.new(:test_verify).run
    assert_equal([<<-MESSAGE.chomp], result.failures.collect(&:to_s))
hello("Alice")
Called 0 times.
Expected 1 times.
    MESSAGE
  end
end
