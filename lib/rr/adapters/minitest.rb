module RR
  module Adapters
    class MiniTest
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
        RR.trim_backtrace = true

        ::MiniTest::Unit::TestCase.class_eval do
          include RRMethods
          include AdapterMethods

          unless instance_methods.any? { |method_name| method_name.to_sym == :setup_with_rr }
            alias_method :setup_without_rr, :setup
            def setup_with_rr
              setup_without_rr
              RR.reset
            end
            alias_method :setup, :setup_with_rr

            alias_method :teardown_without_rr, :teardown
            def teardown_with_rr
              RR.verify
            rescue RR::Errors::RRError => rr_error
              assertion = ::MiniTest::Assertion.new(rr_error.message)
              assertion.set_backtrace(rr_error.backtrace)
              raise assertion
            ensure
              teardown_without_rr
            end
            alias_method :teardown, :teardown_with_rr
          end
        end
      end
    end
  end

  add_adapter :MiniTest
end
