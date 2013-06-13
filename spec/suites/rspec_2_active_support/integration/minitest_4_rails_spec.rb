require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)
require File.expand_path('../../../common/rails_integration_tests', __FILE__)

describe 'Integration with MiniTest 4 and Rails' do
  def adapter_name
    'minitest_4_active_support'
  end

  def test_framework_path
    'minitest/autorun'
  end

  def before_require_test_framework
    <<-EOT
      require 'rails'
      require 'active_support'
    EOT
  end

  def error_test
    with_bootstrap <<-EOT
      class FooTest < ActiveSupport::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_test
    with_bootstrap <<-EOT
      class ActiveSupport::TestCase
        include RR::Adapters::MiniTest
      end

      class FooTest < ActiveSupport::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  def include_adapter_where_rr_included_before_test_framework_test
    with_bootstrap <<-EOT, :include_rr_before_test_framework => true
      class ActiveSupport::TestCase
        include RR::Adapters::MiniTest
      end

      class FooTest < ActiveSupport::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
          object.foo
        end
      end
    EOT
  end

  include AdapterIntegrationTests
  include RailsIntegrationTests
end
