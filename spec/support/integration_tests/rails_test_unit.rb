require File.expand_path('../rails', __FILE__)
require File.expand_path('../../project/rails_test_unit', __FILE__)

module IntegrationTests
  module RailsTestUnit
    include Rails

    def configure_project_generator(generator)
      super
      generator.mixin Project::RailsTestUnit
    end
  end
end
