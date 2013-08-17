require File.expand_path('../../generator', __FILE__)
require File.expand_path('../../test_case/generator', __FILE__)

module TestFile
  class Generator
    include ::Generator

    attr_accessor \
      :include_rr_before_test_framework,
      :autorequire_gems,
      :directory

    attr_reader :project, :index, :prelude, :requires

    def setup(project, index)
      super
      @project = project
      self.include_rr_before_test_framework = project.include_rr_before_test_framework
      self.autorequire_gems = project.autorequire_gems
      @requires = []
      @prelude = ""
      @index = index
      @body = ""
    end

    def add_to_requires(path)
      @requires << path
    end

    def add_to_prelude(string)
      @prelude << string + "\n"
    end

    def add_to_body(string)
      @body << string + "\n"
    end

    def add_test_case(content=nil, &block)
      if content.nil?
        test_case = test_case_generator.call(self, &block)
        content = test_case.string
      end
      @body << content + "\n"
    end

    def add_working_test_case
      add_test_case do |test_case|
        test_case.add_test <<-EOT
          object = Object.new
          mock(object).foo
          object.foo
        EOT
        yield test_case if block_given?
      end
    end

    def call
      path = File.join(directory, "#{filename_prefix}.rb")
      if RR.debug?
        puts "Test file path: #{path}"
      end
      File.open(path, 'w') do |f|
        if RR.debug?
          puts "~ Test file contents ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          puts content
          puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        end
        f.write(content)
      end
    end

    def test_case_generator
      @test_case_generator ||= TestCase::Generator.factory
    end

    def add_test_case_with_adapter_tests
      add_test_case do |test_case|
        test_case.include_adapter_tests
        yield test_case if block_given?
      end
    end

    def add_working_test_case
      add_test_case do |test_case|
        test_case.add_working_test
        yield test_case if block_given?
      end
    end

    def add_working_test_case_with_adapter_tests
      add_working_test_case do |test_case|
        test_case.include_adapter_tests
        yield test_case if block_given?
      end
    end

    private

    def all_requires
      project.requires_with_rr(requires)
    end

    def content
      prelude_lines = []

      if @prelude
        prelude_lines << @prelude
      end

      require_lines = project.require_lines(all_requires)
      prelude_lines.concat(require_lines)

      join_lines(prelude_lines) + @body
    end

    def join_lines(lines)
      lines.map { |line| line + "\n" }.join
    end
  end
end
