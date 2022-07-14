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

    test "different order" do
      assert do
        {a: 1, b: 2}.wildcard_match?(b: 2, a: 1)
      end
    end

    test "different order with wildcard" do
      pattern = {:a => 1, :b => 2, is_a(Symbol) => 3, is_a(Symbol) => 1}
      assert do
        pattern.wildcard_match?(:d => 1, :c => 3, :b => 2, :a => 1)
      end
    end
  end
end
