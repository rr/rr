require File.expand_path('../rails', __FILE__)
require File.expand_path('../../project/rails_test_unit_like', __FILE__)

module IntegrationTests
  module RailsTestUnitLike
    include Rails

    def configure_project_generator(generator)
      super
      generator.mixin Project::RailsTestUnitLike
    end
  end
end
