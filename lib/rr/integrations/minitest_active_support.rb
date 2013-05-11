module RR
  module Integrations
    class MiniTestActiveSupport
      def initialize
        @mt_adapter = MiniTest.new
      end

      def name
        'MiniTest + ActiveSupport'
      end

      def applies?
        @mt_adapter.applies? && defined?(::ActiveSupport::TestCase)
      end

      def hook
        ::ActiveSupport::TestCase.class_eval do
          include RR::Adapters::RRMethods
          include MiniTest::Mixin

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
