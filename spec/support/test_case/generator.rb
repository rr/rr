require File.expand_path('../../generator', __FILE__)

module TestCase
  class Generator
    include ::Generator

    attr_reader :test_file, :string

    def setup(test_file)
      super
      @test_file = test_file
      @prelude = ""
      @before_tests = ""
      @body = ""
      @number_of_tests = 0
    end

    def add_to_prelude(string)
      @prelude << string + "\n"
    end

    def add_to_before_tests(content)
      @before_tests << content + "\n"
    end

    def add_to_body(content)
      @body << content + "\n"
    end

    def add_test(body)
      @body << build_test(@number_of_tests, body) + "\n"
      @number_of_tests += 1
    end

    def add_working_test
      add_test <<-EOT
        object = Object.new
        mock(object).foo
        object.foo
      EOT
    end

    def call
      lines = []
      lines << @prelude
      lines << start_of_test_case
      lines << @before_tests
      lines << @body
      lines << "end"
      @string = lines.map { |line| line + "\n" }.join
    end
  end
end
