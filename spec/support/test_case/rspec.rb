module TestCase
  module RSpec
    def include_adapter_tests
      add_to_before_tests <<-EOT
        include AdapterTests::RSpec
      EOT
    end

    private

    def start_of_test_case
      "describe 'A test case' do"
    end

    def build_test(index, body)
      ["it 'is test ##{index}' do", body, "end"].map { |line| line + "\n" }.join
    end
  end
end
