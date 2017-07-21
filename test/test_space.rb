class TestSpace < Test::Unit::TestCase
  sub_test_case "#reset" do
    sub_test_case "existent" do
      test "respond_to?: instance method" do
        subject = Object.new
        def subject.hello
          :original_hello
        end
        stub(subject).hello {:stub_hello}
        assert_equal(:stub_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
        RR.reset
        assert_equal(:original_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
      end

      test "respond_to?: class method" do
        subject = Class.new do
          def self.hello
            :original_hello
          end
        end
        stub(subject).hello {:stub_hello}
        assert_equal(:stub_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
        RR.reset
        assert_equal(:original_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
      end
    end

    sub_test_case "nonexistent" do
      test "respond_to?: instance method" do
        subject = Object.new
        stub(subject).stub_predicate? {true}
        assert do
          subject.stub_predicate?
        end
        assert do
          subject.respond_to?(:stub_predicate?)
        end
        RR.reset
        assert_raise(NoMethodError) do
          subject.stub_predicate?
        end
        assert do
          not subject.respond_to?(:stub_predicate?)
        end
      end

      test "respond_to?: class method" do
        subject = Class.new
        stub(subject).stub_predicate? {true}
        assert do
          subject.stub_predicate?
        end
        assert do
          subject.respond_to?(:stub_predicate?)
        end
        RR.reset
        assert_raise(NoMethodError) do
          subject.stub_predicate?
        end
        assert do
          not subject.respond_to?(:stub_predicate?)
        end
      end
    end

    sub_test_case "lazy defined" do
      test "respond_to?: instance method" do
        subject = Object.new
        def subject.method_missing(method_name, *args, &block)
          if method_name.to_sym == :hello
            def self.hello
              :original_hello
            end
            hello
          else
            super
          end
        end
        stub(subject).hello {:stub_hello}
        assert_equal(:stub_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
        RR.reset
        assert_equal(:original_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
      end

      test "respond_to?: class method" do
        subject = Class.new do
          def self.method_missing(method_name, *args, &block)
            if method_name.to_sym == :hello
              def self.hello
                :original_hello
              end
              hello
            else
              super
            end
          end
        end
        stub(subject).hello {:stub_hello}
        assert_equal(:stub_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
        RR.reset
        assert_equal(:original_hello, subject.hello)
        assert do
          subject.respond_to?(:hello)
        end
      end
    end
  end
end
