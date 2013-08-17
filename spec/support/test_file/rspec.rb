require File.expand_path('../../test_case/rspec', __FILE__)

module TestFile
  module RSpec
    def setup(project, index)
      super
      test_case_generator.mixin TestCase::RSpec
      self.directory = File.join(project.directory, 'spec')
    end

    def content
      content = super
      <<-EOT + content
        require 'spec_helper'
        require '#{File.join(project.root_dir, 'spec/support/adapter_tests/rspec')}'
      EOT
    end

    def filename_prefix
      "#{"%02d" % @index}_spec"
    end

    # XXX: Do we need this if this is already in RSpecTestCase?
    def add_working_test_case_with_adapter_tests
      add_working_test_case do |test_case|
        test_case.add_to_before_tests <<-EOT
          include AdapterTests::RSpec
        EOT
        yield test_case if block_given?
      end
    end
  end
end
