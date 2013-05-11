require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'MiniTest integration' do
  include AdapterIntegrationTests

  def test_framework_path
    'minitest/autorun'
  end

  def error_test
    <<-EOT
      #{bootstrap}

      class FooTest < MiniTest::Unit::TestCase
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

      class MiniTest::Unit::TestCase
        include RR::Adapters::MiniTest
      end

      class FooTest < MiniTest::Unit::TestCase
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

      class MiniTest::Unit::TestCase
        include RR::Adapters::MiniTest
      end

      class FooTest < MiniTest::Unit::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end
end
