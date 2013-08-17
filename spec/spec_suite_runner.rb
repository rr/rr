class SpecSuiteRunner
  attr_reader :suite

  def initialize(suite)
    @suite = suite
  end

  def call
    command = build_command
    if ENV['RR_DEBUG']
      puts "Running: #{command}"
    end
    execute_command(command)
  end

  private

  def execute_command(command)
    system(command)
    status = $?.exitstatus
    OpenStruct.new(:success? => (status == 0))
  end

  def build_command
    parts = ['env'] + build_env_pairs + ['ruby'] + build_file_list
    parts.join(" ")
  end

  def build_env_pairs
    # If `bundle exec rake` is run instead of just `rake`, Bundler will set
    # RUBYOPT to "-I <path to bundler> -r bundler/setup". This is unfortunate as
    # it causes Bundler to be loaded before we load Bundler in
    # RR::Test.setup_test_suite, thereby rendering our second Bundler.setup a
    # no-op.
    env = suite.env.merge(
      'BUNDLE_BIN_PATH' => '',
      'BUNDLE_GEMFILE' => '',
      'RUBYOPT' => '',
      'ADAPTER' => suite.name
    )
    env.map { |key, val| "#{key}=\"#{val}\"" }
  end

  def build_file_list
    Dir[ File.expand_path("../suites/#{suite.name}/{.,*,**}/*_spec.rb", __FILE__) ]
  end
end
