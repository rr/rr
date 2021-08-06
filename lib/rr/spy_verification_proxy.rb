module RR
  class SpyVerificationProxy
    BlankSlate.call(self)

    def initialize(subject)
      @subject = subject
    end

    if KeywordArguments.fully_supported?
      def method_missing(method_name, *args, **kwargs, &block)
        SpyVerification.new(@subject, method_name, args, kwargs)
      end
    else
      def method_missing(method_name, *args, &block)
        SpyVerification.new(@subject, method_name, args, {})
      end
      ruby2_keywords(:method_missing) if respond_to?(:ruby2_keywords, true)
    end
  end
end
