module RR
  module Integrations
    class TestUnit2ActiveSupport
      def initialize
        @tu2_adapter = RR.adapters_by_name[:TestUnit2]
      end

      def name
        "#{@tu2_adapter.name} + ActiveSupport"
      end

      def applies?
        @tu2_adapter.applies? &&
          defined?(::ActiveSupport::TestCase)
      end

      def hook
        RR.trim_backtrace = true
        RR.overridden_error_class = ::Test::Unit::AssertionFailedError

        ::ActiveSupport::TestCase.class_eval do
          include RR::Adapters::RRMethods
          include TestUnit1::Mixin

          setup do
            RR.reset
          end

          teardown do
            RR.verify
          end
        end
      end
    end

    RR.register_adapter TestUnit2ActiveSupport
  end
end
