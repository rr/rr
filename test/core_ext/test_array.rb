class TestArray < Test::Unit::TestCase
  sub_test_case "#wildcard_match?" do
    test "too much elements" do
      assert do
        ![:a].wildcard_match?([:a, :b])
      end
    end
  end
end
