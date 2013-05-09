module RR
  module Adapters
    class MiniTest4
      module AdapterMethods
        def assert_received(subject, &block)
          block.call(received(subject)).call
        end
      end

      def name
        'MiniTest'
      end

      def applies?
        defined?(::MiniTest)
      end

      def hook
        ::MiniTest::Unit::TestCase.class_eval do
          include RRMethods
          include AdapterMethods

          unless instance_methods.any? { |method_name| method_name.to_sym == :setup_with_rr }
            alias_method :setup_without_rr, :setup
            def setup_with_rr
              setup_without_rr
              RR.reset
              RR.trim_backtrace = true
              RR.overridden_error_class = ::MiniTest::Assertion
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
    end
  end
end
