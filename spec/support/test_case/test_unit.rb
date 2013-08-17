module TestCase
  module TestUnit
    attr_accessor :superclass

    def include_adapter_tests
      add_to_before_tests <<-EOT
        include AdapterTests::TestUnit
      EOT
    end

    private

    def start_of_test_case
      "class FooTest < #{superclass}"
    end

    def build_test(index, body)
      ["def test_#{index}", body, "end"].map { |line| line + "\n" }.join
    end
  end
end
