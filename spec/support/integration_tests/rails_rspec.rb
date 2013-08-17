require File.expand_path('../rails', __FILE__)
require File.expand_path('../../project/rails_rspec', __FILE__)

module IntegrationTests
  module RailsRSpec
    include Rails

    def configure_project_generator(generator)
      super
      generator.mixin Project::RailsRSpec
    end
  end
end
