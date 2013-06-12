require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'Test::Unit 1 integration' do
  def adapter_name
    'test_unit_1'
  end

  def test_framework_path
    'test/unit'
  end

  def error_test
    with_bootstrap <<-EOT
      class FooTest < Test::Unit::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    with_bootstrap <<-EOT
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
