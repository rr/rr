module Project
  module TestUnitLike
    def test_runner_command
      ruby_command('rake test')
    end
  end
end
