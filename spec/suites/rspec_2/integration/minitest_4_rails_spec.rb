require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)
require File.expand_path('../../../common/rails_integration_test', __FILE__)

describe 'Integration between MiniTest 4 and Rails' do
  def adapter_name
    'minitest_4'
  end

  def additional_bootstrap
    <<-EOT
      require 'rails'
      require 'active_support'
    EOT
  end

  def test_framework_path
    'minitest/autorun'
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
    <<-EOT
      #{bootstrap :include_rr_before => true}

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
  include IntegrationWithRails
end
