require 'rubygems'
require 'session'
require 'tempfile'

module AdapterIntegrationTests
  def debug?
    ENV['RR_DEBUG'] == '1'
  end

  def run_fixture_tests(content)
    output = nil
    f = Tempfile.new('rr_test_fixture')
    puts content if debug?
    f.write(content)
    f.close
    bash = Session::Bash.new
    cmd = "ruby -I #{lib_path} #{f.path} 2>&1"
    puts cmd if debug?
    stdout, stderr = bash.execute(cmd)
    success = !!(bash.exit_status == 0 || stdout =~ /Finished/)
    if debug? or !success
      puts stdout
      puts stderr
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

  def ruby_18?
    RUBY_VERSION =~ /^1\.8/
  end

  def bootstrap(opts={})
    str = ""
    str << "require 'rubygems'\n"
    str << "require 'rr'\n" if opts[:include_rr_before]
    str << <<-EOT
      require '#{test_framework_path}'
      #{additional_bootstrap}
    EOT
    str << "require 'rr'\n" unless opts[:include_rr_before]
    str
  end

  def additional_bootstrap
    ""
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

      specify "it is still possible to include the adapter into the test framework manually" do
        output = run_fixture_tests(include_adapter_test)
        all_tests_should_pass(output)
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
