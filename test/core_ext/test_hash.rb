class TestHash < Test::Unit::TestCase
  sub_test_case "#wildcard_match?" do
    test "too much keys" do
      assert do
        !{:a => 1}.wildcard_match?(:a => 1, :b => 2)
      end
    end
  end
end
