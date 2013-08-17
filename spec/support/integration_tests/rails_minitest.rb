require File.expand_path('../rails', __FILE__)
require File.expand_path('../../project/rails_minitest', __FILE__)

module IntegrationTests
  module RailsMinitest
    include Rails

    def configure_project_generator(generator)
      super
      generator.mixin Project::RailsMinitest
    end
  end
end
