require File.expand_path('../ruby', __FILE__)
require File.expand_path('../../project/ruby_rspec', __FILE__)

module IntegrationTests
  module RubyRSpec
    include Ruby

    def configure_project_generator(generator)
      super
      generator.mixin Project::RubyRSpec
    end
  end
end
