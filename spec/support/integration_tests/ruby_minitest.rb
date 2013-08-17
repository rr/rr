require File.expand_path('../ruby', __FILE__)
require File.expand_path('../../project/ruby_minitest', __FILE__)

module IntegrationTests
  module RubyMinitest
    include Ruby

    def configure_project_generator(generator)
      super
      generator.mixin Project::RubyMinitest
    end
  end
end
