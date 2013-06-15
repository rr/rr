module RR
  module Integrations
    class RSpec1
      module Mixin
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
        defined?(::Spec) &&
        defined?(::Spec::VERSION::STRING) &&
        ::Spec::VERSION::STRING =~ /^1/
      end

      def hook
        ::Spec::Runner.configure do |config|
          config.mock_with Mixin
          config.include RR::Adapters::RRMethods
        end
        patterns = ::Spec::Runner::QuietBacktraceTweaker::IGNORE_PATTERNS
        unless patterns.include?(RR::Errors::BACKTRACE_IDENTIFIER)
          patterns.push(RR::Errors::BACKTRACE_IDENTIFIER)
        end
      end
    end

    RR.register_adapter RSpec1
  end
end
