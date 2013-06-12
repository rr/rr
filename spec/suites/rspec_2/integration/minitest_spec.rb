require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'Integration with Minitest >= 5' do
  def adapter_name
    'minitest'
  end

  def test_framework_path
    'minitest/autorun'
  end

  def error_test
    with_bootstrap <<-EOT
      class FooTest < Minitest::Test
        def test_foo
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    with_bootstrap <<-EOT
      class Minitest::Test
        include RR::Adapters::MiniTest
      end

      class FooTest < Minitest::Test
        def test_foo
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  def include_adapter_where_rr_included_before_test_framework_test
    with_bootstrap <<-EOT, :include_rr_before => true
      class Minitest::Test
        include RR::Adapters::MiniTest
      end

      class FooTest < Minitest::Test
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
