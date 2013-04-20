module RR
  module Adapters
    class RSpec1
      module AdapterMethods
        def setup_mocks_for_rspec
          RR.reset
        end

        def verify_mocks_for_rspec
          RR.verify
        end

        def teardown_mocks_for_rspec
          RR.reset
        end

        def have_received(method = nil)
          RSpec::InvocationMatcher.new(method)
        end
      end

      def name
        'RSpec 1'
      end

      def applies?
        defined?(::Spec)
      end

      def hook
        ::Spec::Runner.configure do |config|
          config.mock_with AdapterMethods
          config.include RRMethods
        end
        patterns = ::Spec::Runner::QuietBacktraceTweaker::IGNORE_PATTERNS
        unless patterns.include?(RR::Errors::BACKTRACE_IDENTIFIER)
          patterns.push(RR::Errors::BACKTRACE_IDENTIFIER)
        end
      end
    end
  end

  add_adapter :RSpec1
end
