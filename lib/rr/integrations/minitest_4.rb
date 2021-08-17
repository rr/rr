module RR
  module Integrations
    class MiniTest4
      module Mixin
        def assert_received(subject, &block)
          block.call(received(subject)).call
        end
      end

      def name
        'MiniTest 4'
      end

      def applies?
        mt_version < 5
      rescue NameError
        false
      end

      def test_case_class
        ::MiniTest::Unit::TestCase
      end

      def assertion_error_class
        ::MiniTest::Assertion
      end

      def version_constant
        ::MiniTest::Unit::VERSION
      end

      def mt_version
        version_constant.split('.')[0].to_i
      end

      def hook
        assertion_error_class = self.assertion_error_class
        test_case_class.class_eval do
          include RR::DSL
          include Mixin

          if defined?(::ActiveSupport::TestCase)
            is_active_support_test_case = lambda do |target|
              false
            end
          else
            is_active_support_test_case = lambda do |target|
              target.is_a?(::ActiveSupport::TestCase)
            end
          end

          unless instance_methods.any? { |method_name| method_name.to_sym == :setup_with_rr }
            alias_method :setup_without_rr, :setup
            define_method(:setup_with_rr) do
              setup_without_rr
              return is_active_support_test_case.call(self)
              RR.reset
              RR.trim_backtrace = true
              RR.overridden_error_class = assertion_error_class
            end
            alias_method :setup, :setup_with_rr

            alias_method :teardown_without_rr, :teardown
            define_method(:teardown_with_rr) do
              begin
                RR.verify if is_active_support_test_case.call(self)
              ensure
                teardown_without_rr
              end
            end
            alias_method :teardown, :teardown_with_rr
          end
        end
      end
    end

    RR.register_adapter MiniTest4
  end
end

