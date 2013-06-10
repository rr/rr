require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/adapter_integration_tests', __FILE__)

describe 'Test::Unit 2 integration' do
  def bootstrap(opts={})
    str = ""
    str << "require 'rubygems'\n"
    str << "require 'rr'\n" if opts[:include_rr_before]
    str << "require 'test/unit'\n"
    str << "require 'rr'\n" unless opts[:include_rr_before]
    str
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

  def include_adapter_where_rr_included_before_test_framework_test
    <<-EOT
      #{bootstrap :include_rr_before => true}

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
