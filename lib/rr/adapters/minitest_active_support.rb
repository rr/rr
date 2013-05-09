module RR
  module Adapters
    class MiniTestActiveSupport
      def initialize
        @mt_adapter = MiniTest4.new
      end

      def name
        'MiniTest w/ ActiveSupport'
      end

      def applies?
        @mt_adapter.applies? && defined?(::ActiveSupport::TestCase)
      end

      def hook
        ::ActiveSupport::TestCase.class_eval do
          include RRMethods
          include MiniTest4::AdapterMethods

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
  end
end
