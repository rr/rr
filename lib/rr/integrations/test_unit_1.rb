module RR
  module Integrations
    class TestUnit1
      module Mixin
        def assert_received(subject, &block)
          block.call(received(subject)).call
        end
      end

      def name
        'Test::Unit 1'
      end

      def applies?
        defined?(::Test::Unit) &&
        defined?(::Test::Unit::TestCase) &&
        !has_test_unit_version? &&
        !test_unit_just_wraps_minitest?
      end

      def hook
        ::Test::Unit::TestCase.class_eval do
          include RR::Adapters::RRMethods
          include Mixin

          unless instance_methods.detect {|method_name| method_name.to_sym == :setup_with_rr }
            alias_method :setup_without_rr, :setup
            def setup_with_rr
              setup_without_rr
              RR.reset
              RR.trim_backtrace = true
              RR.overridden_error_class = ::Test::Unit::AssertionFailedError
            end
            alias_method :setup, :setup_with_rr

            alias_method :teardown_without_rr, :teardown
            def teardown_with_rr
              RR.verify
            ensure
              teardown_without_rr
            end
            alias_method :teardown, :teardown_with_rr
          end
        end
      end

      def test_unit_just_wraps_minitest?
        defined?(::Test::Unit::TestCase) &&
        defined?(::MiniTest::Unit::TestCase) &&
        ::Test::Unit::TestCase < ::MiniTest::Unit::TestCase
      end

      def has_test_unit_version?
        require 'test/unit/version'
        true
      rescue LoadError
        false
      end
    end

    RR.register_adapter TestUnit1
  end
end
