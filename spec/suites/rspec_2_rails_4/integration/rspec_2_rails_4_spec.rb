require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_tests', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)
require File.expand_path('../../../common/rails_integration_tests', __FILE__)

describe 'Integration with RSpec 2 and Rails 4' do
  def assert_equal(expected, actual)
    expect(actual).to eq actual
  end

  def assert_raise(error, message=nil, &block)
    expect(&block).to raise_error(error, message)
  end

  def adapter_name
    'rspec_2_rails_4'
  end

  def applicable_adapter_names
    [:RSpec2]
  end

  def test_framework_path
    %w(rspec/autorun rspec/rails)
  end

  def before_require_test_framework
    <<-EOT
      require 'rails/all'
      #require 'active_support'
      #require 'active_support/test_case'
    EOT
  end

  def after_require_test_framework
    <<-EOT
      RSpec.configure do |c|
        c.use_transactional_fixtures = true
      end
    EOT
  end

  def error_test
    with_bootstrap <<-EOT
      describe 'A test' do
        it 'is a test' do
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    with_bootstrap <<-EOT
      RSpec.configure do |c|
        c.mock_with :rr
      end

      describe 'A test' do
        it 'is a test' do
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  def include_adapter_where_rr_included_before_test_framework_test
    with_bootstrap <<-EOT, :include_rr_before_test_framework => true
      RSpec.configure do |c|
        c.mock_with :rr
      end

      describe 'A test' do
        it 'is a test' do
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  def database_properly_rolled_back_test
    with_active_record_bootstrap <<-EOT
      describe Person do
        it 'is a test' do
          Person.create!(:name => 'Joe Blow')
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  specify "it is still possible to use a custom RSpec-2 adapter" do
    suite = with_bootstrap <<-EOT
      module RR
        module Adapters
          module RSpec2
            include RRMethods

            def setup_mocks_for_rspec
              RR.reset
            end

            def verify_mocks_for_rspec
              RR.verify
            end

            def teardown_mocks_for_rspec
              RR.reset
            end

            def have_received(method = nil)
              RR::Adapters::Rspec::InvocationMatcher.new(method)
            end
          end
        end
      end

      RSpec.configure do |c|
        c.mock_with RR::Adapters::RSpec2
      end

      describe 'RR' do
        specify 'mocks work' do
          object = Object.new
          mock(object).foo
          object.foo
        end

        specify 'have_received works' do
          object = Object.new
          stub(object).foo
          object.foo
          object.should have_received.foo
        end
      end
    EOT
    output = run_fixture_tests(suite)
    all_tests_should_pass(output)
  end

  include AdapterTests
  instance_methods.each do |method_name|
    if method_name =~ /^test_(.+)$/
      it(method_name) { __send__(method_name) }
    end
  end

  include AdapterIntegrationTests
  include RailsIntegrationTests
end
