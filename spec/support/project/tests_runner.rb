module Project
  class TestsRunner
    def self.call(project)
      runner = new(project)
      yield runner if block_given?
      runner.call
    end

    attr_reader :project
    attr_accessor :command

    def initialize(project)
      @project = project
      self.command = project.test_runner_command
    end

    def call
      match = command.match(/^((?:\w+=[^ ]+ )*)(.+)$/)
      project.run_command_within(match[2], :env => match[1])
    end
  end
end
