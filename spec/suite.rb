require 'session'

class SpecSuite
  def self.def_runner(runner_name, runner_desc, program_name, suffix, opts={}, &block)
    adapter_name = opts[:adapter] || runner_name
    path = opts[:path] || runner_name
    env = opts[:env] || {}
    args = opts[:args] || ""
    runner_method = "run_#{runner_name}"
    define_method(runner_method) do
      run_command(build_command(program_name, adapter_name, path, suffix, env, args))
    end
    runners << [runner_name, runner_desc]
  end

  def self.runners
    @runners ||= []
  end

  def self.ruby_18?
    RUBY_VERSION =~ /^1\.8/
  end

  def define_tasks(ctx)
    suite = self

    SpecSuite.runners.each do |runner_name, runner_desc|
      runner_method = "run_#{runner_name}"

      appraisal_name = self.class.ruby_18? ? 'ruby_18_' : 'ruby_19_'
      appraisal_name << runner_name.to_s

      ctx.__send__ :desc, "Run #{runner_desc} tests"
      ctx.__send__ :task, :"spec:#{runner_name}" => :"appraisal:#{appraisal_name}:install" do
        session = suite.__send__(runner_method)
        if session.exit_status != 0
          raise "#{runner_desc} suite failed"
        end
      end
    end

    ctx.__send__ :desc, "Run all tests"
    ctx.__send__ :task, :spec do
      sessions = []
      SpecSuite.runners.each do |runner_name, runner_desc|
        puts "=== Running #{runner_desc} tests ================================================"
        runner_method = "run_#{runner_name}"
        sessions << suite.__send__(runner_method)
        puts
      end
      if sessions.any? {|session| session.exit_status != 0 }
        raise "Spec suite failed"
      end
    end
  end

  if ruby_18?
    def_runner :test_unit_1, 'Test::Unit 1', 'ruby', 'test'
  end

  if ruby_18?
    def_runner :test_unit_2, 'Test::Unit 2.4.x', 'ruby', 'test'
    def_runner :test_unit_2_rails_2, 'Test::Unit 2.4.x + Rails 2', 'ruby', 'test'
  else
    def_runner :test_unit_200, 'Test::Unit 2.0.0', 'ruby', 'test'
    def_runner :test_unit_200_rails_3, 'Test::Unit 2.0.0 + Rails 3', 'ruby', 'test'
    def_runner :test_unit_2, 'Test::Unit >= 2.5', 'ruby', 'test'
    def_runner :test_unit_2_rails_3, 'Test::Unit >= 2.5 + Rails 3', 'ruby', 'test'
    def_runner :test_unit_2_rails_4, 'Test::Unit >= 2.5 + Rails 4.0.0.rc1', 'ruby', 'test'
  end

  unless ruby_18?
    def_runner :minitest_4, 'MiniTest 4', 'ruby', 'test'
    def_runner :minitest, 'Minitest', 'ruby', 'test'
  end

  if ruby_18?
    def_runner :rspec_1, 'RSpec 1', 'spec', 'spec',
      :args => '--format progress'
    def_runner :rspec_1_rails_2, 'RSpec 1 + Rails 2', 'spec', 'spec',
      :args => '--format progress'
  else
    def_runner :rspec_2, 'RSpec 2', 'rspec', 'spec',
      :env => {'SPEC_OPTS' => '--format progress'}
    def_runner :rspec_2_rails_3, 'RSpec 2 + Rails 3', 'rspec', 'spec',
      :env => {'SPEC_OPTS' => '--format progress'}
    def_runner :rspec_2_rails_4, 'RSpec 2 + Rails 4.0.0.rc1', 'rspec', 'spec',
      :env => {'SPEC_OPTS' => '--format progress'}
  end

  private

  def run_command(*parts)
    session = Session::Bash.new
    command = parts.join(" ")
    session.execute command, :out => STDOUT, :err => STDERR
    session
  end

  def build_command(program_name, adapter_name, path, suffix, env, args)
    env = env.dup
    # If `bundle exec rake` is run instead of just `rake`, Bundler will set
    # RUBYOPT to "-I <path to bundler> -r bundler/setup". This is unfortunate as
    # it causes Bundler to be loaded before we load Bundler in
    # RR::Test.setup_test_suite, thereby rendering our second Bundler.setup a
    # no-op.
    env['RUBYOPT'] = ""
    env['ADAPTER'] = adapter_name
    env_pairs = env.map {|k,v| "#{k}=\"#{v}\"" }
    file_list = build_file_list(path, suffix)
    ['env'] + env_pairs + ['ruby'] + file_list + [args]
  end

  def build_file_list(adapter_name, suffix)
    Dir[ File.expand_path("../suites/#{adapter_name}/{.,*,**}/*_#{suffix}.rb", __FILE__) ]
  end
end
