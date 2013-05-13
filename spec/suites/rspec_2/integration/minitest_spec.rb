require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'MiniTest integration' do
  def test_framework_path
    'minitest/autorun'
  end

  def error_test
    <<-EOT
      #{bootstrap}

      class FooTest < Minitest::Test
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
    <<-EOT
      #{bootstrap :include_rr_before => true}

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
