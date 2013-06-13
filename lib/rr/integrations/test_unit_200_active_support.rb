module RR
  module Integrations
    class TestUnit200ActiveSupport
      def initialize
        @mt4as_adapter = RR.adapters_by_name[:MiniTest4ActiveSupport]
        @tu200_adapter = RR.adapters_by_name[:TestUnit200]
      end

      def name
        "#{@tu200_adapter.name} + ActiveSupport"
      end

      def applies?
        @tu200_adapter.applies? && defined?(::ActiveSupport::TestCase)
      end

      def hook
        @mt4as_adapter.hook
      end
    end

    RR.register_adapter TestUnit200ActiveSupport
  end
end

