require File.expand_path('../ruby', __FILE__)
require File.expand_path('../../project/ruby_test_unit', __FILE__)

module IntegrationTests
  module RubyTestUnit
    include Ruby

    def configure_project_generator(generator)
      super
      generator.mixin Project::RubyTestUnit
    end
  end
end
