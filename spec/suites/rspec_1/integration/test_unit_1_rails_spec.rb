require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)
require File.expand_path('../../../common/rails_integration_test', __FILE__)

describe 'Integration between TestUnit and Rails' do
  include AdapterIntegrationTests
  include IntegrationWithRails

  def bootstrap
    <<-EOT
      RAILS_ROOT = File.expand_path(__FILE__)
      require 'test/unit'

      require 'rubygems'
      require 'rack'
      require 'active_support/all'
      require 'action_controller'
      require 'active_support/test_case'

      require 'rr'
    EOT
  end

  def error_test
    <<-EOT
      #{bootstrap}

      class FooTest < ActiveSupport::TestCase
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
end
