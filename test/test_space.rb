class TestSpace < Test::Unit::TestCase
  sub_test_case "#reset" do
    test "respond_to?: instance method" do
      subject = Object.new
      stub(subject).exist? {true}
      assert do
        subject.exist?
      end
      assert do
        subject.respond_to?(:exist?)
      end
      RR.reset
      assert_raise(NoMethodError) do
        subject.exist?
      end
      assert do
        not subject.respond_to?(:exist?)
      end
    end

    test "respond_to?: class method" do
      subject = Class.new
      stub(subject).exist? {true}
      assert do
        subject.exist?
      end
      assert do
        subject.respond_to?(:exist?)
      end
      RR.reset
      assert_raise(NoMethodError) do
        subject.exist?
      end
      assert do
        not subject.respond_to?(:exist?)
      end
    end
  end
end
