require File.expand_path('../../test_case/test_unit', __FILE__)

module TestFile
  module TestUnit
    def setup(project, index)
      super
      test_case_generator.mixin TestCase::TestUnit
      self.directory = File.join(project.directory, 'test')
      test_case_generator.configure do |test_case|
        test_case.superclass = 'Test::Unit::TestCase'
      end
    end

    def content
      content = super
      <<-EOT + content
        require 'test_helper'
        require '#{File.join(project.root_dir, 'spec/support/adapter_tests/test_unit')}'
      EOT
    end

    def filename_prefix
      "#{"%02d" % @index}_test"
    end

    # XXX: Do we need this if this is already in TestUnitTestCase?
    def add_working_test_case_with_adapter_tests
      add_working_test_case do |test_case|
        test_case.add_to_before_tests <<-EOT
          include AdapterTests::TestUnit
        EOT
        yield test_case if block_given?
      end
    end
  end
end
