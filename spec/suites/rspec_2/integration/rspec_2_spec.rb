require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_tests', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'Integration with RSpec 2' do
  include AdapterTests
  instance_methods.each do |method_name|
    if method_name =~ /^test_(.+)$/
      it(method_name) { __send__(method_name) }
    end
  end

  include AdapterIntegrationTests

  def assert_equal(expected, actual)
    expect(actual).to eq actual
  end

  def assert_raise(error, message=nil, &block)
    expect(&block).to raise_error(error, message)
  end

  def test_framework_path
    'rspec/autorun'
  end

  def error_test
    <<-EOT
      #{bootstrap}

      describe 'A test' do
        it do
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    <<-EOT
      #{bootstrap}

      RSpec.configure do |c|
        c.mock_with :rr
      end

      describe 'A test' do
        it do
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end
end
