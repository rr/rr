require File.expand_path('../test_unit', __FILE__)

module TestFile
  module RailsTestUnit
    include TestUnit

    def setup(project, index)
      super
      self.directory =
        if project.rails_version == 4
          File.join(project.directory, 'test', 'models')
        else
          File.join(project.directory, 'test', 'unit')
        end
      test_case_generator.configure do |test_case|
        test_case.superclass = 'ActiveSupport::TestCase'
      end
    end

    # Don't require anything; this will happen in the test helper
    def all_requires
      []
    end
  end
end
