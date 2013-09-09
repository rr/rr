module RR
  module Integrations
    module RSpec
      class InvocationMatcher < SpyVerificationProxy
        attr_reader :failure_message, :spy_verification_proxy

        def initialize(method = nil)
          @verification = nil
          @subject = nil
          method_missing(method) if method
        end

        def matches?(subject)
          @verification.subject = subject
          calls = RR::Space.instance.recorded_calls
          if error = calls.match_error(@verification)
            @failure_message = error.message
            false
          else
            true
          end
        end

        def nil?
          false
        end

        def method_missing(method_name, *args, &block)
          if @verification
            @verification.send(method_name, *args)
          else
            @verification = super
          end
          self
        end
      end
    end
  end
end
