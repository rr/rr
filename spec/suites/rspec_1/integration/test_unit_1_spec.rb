require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'Test::Unit 1 integration' do
  def bootstrap
    <<-EOT
      require 'test/unit'
      require 'rubygems'
      require 'rr'
    EOT
  end

  def error_test
    <<-EOT
      #{bootstrap}

      class FooTest < Test::Unit::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    <<-EOT
      #{bootstrap}

      class Test::Unit::TestCase
        include RR::Adapters::TestUnit
      end

      class FooTest < Test::Unit::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  include AdapterIntegrationTests
end
