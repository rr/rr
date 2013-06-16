require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)
require File.expand_path('../../../common/rails_integration_tests', __FILE__)

describe 'Integration with Test::Unit 2.4.x and Rails 2' do
  def adapter_name
    'test_unit_2_rails_2'
  end

  def test_framework_path
    'test/unit'
  end

  def before_require_test_framework
    <<-EOT
      RAILS_ROOT = File.expand_path(__FILE__)
      require 'rack'
    EOT
  end

  def after_require_test_framework
    <<-EOT
      require 'test/unit'
      require 'active_support/all'
      require 'action_controller'
      require 'active_support/test_case'
    EOT
  end

  def error_test
    with_bootstrap <<-EOT
      class ActiveSupport::TestCase
        include RR::Adapters::TestUnit
      end

      class FooTest < ActiveSupport::TestCase
        def test_foo
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def include_adapter_where_rr_included_before_test_framework_test
    with_bootstrap <<-EOT, :include_rr_before_test_framework => true
      class ActiveSupport::TestCase
        include RR::Adapters::TestUnit
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
