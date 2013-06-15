require 'rubygems'
require 'session'
require 'tempfile'
require 'appraisal'

module AdapterIntegrationTests
  ROOT_DIR = File.expand_path('../../../..', __FILE__)
  LIB_DIR = File.join(ROOT_DIR, 'lib')
  TEMP_DIR = '/tmp/rr_integration_tests'

  def create_link(filename)
    FileUtils.ln_s(File.join(ROOT_DIR, filename), File.join(TEMP_DIR, filename))
  end

  def debug?
    RR.debug?
  end

  def ruby_18?
    RUBY_VERSION =~ /^1\.8/
  end

  def run_fixture_tests(content)
    fixture_path = File.join(TEMP_DIR, 'rr_test_fixture_spec.rb')
    FileUtils.rm_f(fixture_path)
    f = File.open(fixture_path, 'w')
    puts content if debug?
    f.write(content)
    f.close
    bash = Session::Bash.new
    # Bundler will set RUBYOPT to "-I <path to bundler> -r bundler/setup".
    # This is unfortunate as it causes Bundler to be loaded before we
    # load Bundler in RR::Test.setup_test_suite, thereby rendering our
    # second Bundler.setup a no-op.
    command = "env RUBYOPT='' ruby -I #{LIB_DIR} #{f.path} 2>&1"
    puts command if debug?
    stdout, _ = bash.execute(command)
    exit_status = bash.exit_status
    success = !!(exit_status == 0 || stdout =~ /Finished/)
    if debug? or !success
      puts stdout
    end
    success.should be_true
    stdout
  ensure
    FileUtils.rm_f(fixture_path) if fixture_path
  end

  def test_helper_path
    File.join(ROOT_DIR, 'spec/global_helper.rb')
  end

  def full_bootstrap(opts={})
    str = ""
    str << <<-EOT
      require 'fileutils'
      temp_dir = '#{TEMP_DIR}'
      Dir.chdir(temp_dir)
      require '#{test_helper_path}'
      RR::Test.setup_test_suite('#{adapter_name}')
    EOT
    str << opts[:before_require_rr] if opts[:before_require_rr]
    str << require_rr if opts[:include_rr_before_test_framework]
    str << require_test_framework
    str << require_rr unless opts[:include_rr_before_test_framework]
    str
  end

  def require_rr
    "require 'rr'\n"
  end

  def before_require_test_framework
    ""
  end

  def require_test_framework
    [
      before_require_test_framework,
      "require '#{test_framework_path}'",
      after_require_test_framework
    ].join("\n")
  end

  def after_require_test_framework
    ""
  end

  def with_bootstrap(*args)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    str = args.first || ""
    [full_bootstrap(opts), str].join("\n")
  end

  def all_tests_should_pass(output)
    if output =~ /(\d+) failure/
      $1.should be == '0'
    end
    if output =~ /(\d+) error/
      $1.should be == '0'
    end
  end

  def self.included(base)
    base.class_eval do
      before :all do
        FileUtils.rm_rf(TEMP_DIR)
        FileUtils.mkdir(TEMP_DIR)
        create_link('Gemfile')
        create_link('Appraisals')
        create_link('gemfiles')
      end

      after :all do
        FileUtils.rm_rf(TEMP_DIR)
      end

      specify "when RR raises an error it raises a failure not an exception" do
        output = run_fixture_tests(error_test)
        output.should match /1 failure/
      end

      if method_defined?(:include_adapter_test)
        specify "it is still possible to include the adapter into the test framework manually" do
          output = run_fixture_tests(include_adapter_test)
          all_tests_should_pass(output)
        end
      end

      if method_defined?(:include_adapter_where_rr_included_before_test_framework_test)
        specify "it is still possible to include the adapter into the test framework manually when RR is included before the test framework" do
          output = run_fixture_tests(include_adapter_where_rr_included_before_test_framework_test)
          all_tests_should_pass(output)
        end
      end

      # issue #29
      specify "loading Cucumber doesn't mess up RR's autohook mechanism" do
        FileUtils.mkdir(File.join(TEMP_DIR, 'features'))
        loading_cucumber_test = <<-EOT
          require 'fileutils'
          temp_dir = '#{TEMP_DIR}'
          Dir.chdir(temp_dir)
          require '#{test_helper_path}'
          RR::Test.setup_test_suite('#{adapter_name}')
          # This is what gets loaded within the `cucumber` executable
          require 'cucumber/rspec/disable_option_parser'
          require 'rr'
        EOT
        run_fixture_tests(loading_cucumber_test)
      end
    end
  end
end
