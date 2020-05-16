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

    sub_test_case "#any_instance_of" do
      test "inherit" do
        parent_class = Class.new
        subject_class = Class.new(parent_class)
        subject_to_s_method = subject_class.instance_method(:to_s)

        any_instance_of(parent_class, :to_s => "Parent is stubbed")
        any_instance_of(parent_class, :stubbed => lambda {:value})

        any_instance_of(subject_class, :to_s => "Subject is stubbed")

        assert_equal("Parent is stubbed", parent_class.new.to_s)

        subject = subject_class.new
        assert_equal("Subject is stubbed", subject.to_s)
        assert_equal(:value, subject.stubbed)

        RR.reset

        assert_equal(subject_to_s_method.bind(subject).call,
                     subject.to_s)
        assert_raise(NoMethodError) do
          subject.stubbed
        end
      end
    end
  end
end
