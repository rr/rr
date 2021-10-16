class TestIntegerationMinitest < Test::Unit::TestCase
  setup do
    omit("Require Minitest") unless defined?(::Minitest)
    omit("Require not Active Support") if defined?(::ActiveSupport::TestCase)
  end

  test("verify") do
    test_class = Class.new(Minitest::Test) do
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
