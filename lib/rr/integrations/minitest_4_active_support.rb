module RR
  module Integrations
    class MiniTest4ActiveSupport
      def initialize
        @mt_adapter = parent_adapter_class.new
      end

      def parent_adapter_class
        MiniTest4
      end

      def name
        'MiniTest 4 + ActiveSupport'
      end

      def applies?
        @mt_adapter.applies? && defined?(::ActiveSupport::TestCase)
      end

      def hook
        parent_adapter_class = self.parent_adapter_class
        ::ActiveSupport::TestCase.class_eval do
          include RR::DSL
          include parent_adapter_class::Mixin

          setup do
            RR.reset
            RR.trim_backtrace = true
            RR.overridden_error_class = ::ActiveSupport::TestCase::Assertion
          end

          teardown do
            RR.verify
          end
        end
      end
    end

    RR.register_adapter MiniTest4ActiveSupport
  end
end
