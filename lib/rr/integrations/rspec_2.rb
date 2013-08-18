module RR
  module Integrations
    class RSpec2 < RSpec1
      def name
        'RSpec 2'
      end

      def applies?
        defined?(::RSpec) &&
        defined?(::RSpec::Core::Version::STRING) &&
        ::RSpec::Core::Version::STRING =~ /^2/
      end

      def hook
        ::RSpec.configure do |config|
          config.mock_with Mixin
          config.include RR::Adapters::RRMethods
        end

        patterns =
          if ::RSpec.configuration.respond_to?(:backtrace_exclusion_patterns)
            ::RSpec.configuration.backtrace_exclusion_patterns
          else
            ::RSpec.configuration.backtrace_clean_patterns
          end

        unless patterns.include?(RR::Errors::BACKTRACE_IDENTIFIER)
          patterns.push(RR::Errors::BACKTRACE_IDENTIFIER)
        end
      end
    end

    RR.register_adapter RSpec2
  end
end
