require 'rubygems'
require 'session'
require 'tempfile'

module AdapterIntegrationTests
  def debug?
    false
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

  def bootstrap
    <<-EOT
      require 'rubygems'
      require '#{test_framework_path}'
      #{additional_bootstrap}
      require 'rr'
    EOT
  end

  def additional_bootstrap
    ""
  end

  def self.included(base)
    base.class_eval do
      specify "when RR raises an error it raises a failure not an exception" do
        output = run_fixture_tests(error_test)
        output.should match /1 failure/
      end

      specify "it is still possible to include the adapter into the test framework manually" do
        run_fixture_tests(include_adapter_test)
      end
    end
  end
end
