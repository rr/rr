require 'rubygems'
require 'session'
require 'tempfile'
require 'appraisal'

module AdapterIntegrationTests
  def debug?
    RR.debug?
  end

  def ruby_18?
    RUBY_VERSION =~ /^1\.8/
  end

  def run_fixture_tests(content)
    f = Tempfile.new('rr_test_fixture')
    puts content if debug?
    f.write(content)
    f.close
    bash = Session::Bash.new
    # Bundler will set RUBYOPT to "-I <path to bundler> -r bundler/setup".
    # This is unfortunate as it causes Bundler to be loaded before we
    # load Bundler in RR::Test.setup_test_suite, thereby rendering our
    # second Bundler.setup a no-op.
    command = "env RUBYOPT='' ruby -I #{lib_path} #{f.path} 2>&1"
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
    f.unlink
  end

  def lib_path
    File.expand_path('../../../../lib', __FILE__)
  end

  def test_helper_path
    File.expand_path('../../../global_helper', __FILE__)
  end

  def full_bootstrap(opts={})
    str = ""
    str << <<-EOT
      require '#{test_helper_path}'
      RR::Test.setup_test_suite('#{adapter_name}')
    EOT
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

  def with_bootstrap(str, opts={})
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
    end
  end
end
