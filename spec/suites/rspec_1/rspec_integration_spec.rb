require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../../common/adapter_tests', __FILE__)

describe 'Integration with RSpec 1' do
  include AdapterTests

  def assert_equal(expected, actual)
    actual.should be == expected
  end

  def assert_raise(error, message=nil, &block)
    expect(&block).to raise_error(error, message)
  end

  instance_methods.each do |method_name|
    if method_name =~ /^test_(.+)$/
      it(method_name) { __send__(method_name) }
    end
  end
end
