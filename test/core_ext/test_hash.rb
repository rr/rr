class TestHash < Test::Unit::TestCase
  sub_test_case "#wildcard_match?" do
    test "is_a" do
      assert do
        {is_a(Symbol) => 1}.wildcard_match?(:a => 1)
      end
    end

    test "too much keys" do
      assert do
        !{:a => 1}.wildcard_match?(:a => 1, :b => 2)
      end
    end
  end
end
