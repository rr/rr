require File.expand_path('../../generator', __FILE__)

module TestHelper
  class Generator
    include ::Generator

    attr_reader :project, :requires, :prelude

    def setup(project)
      super
      @project = project
      @requires = []
      @prelude = ""
    end

    def add_to_requires(path)
      @requires << path
    end

    def add_to_prelude(string)
      @prelude << string + "\n"
    end

    def call
    end
  end
end
