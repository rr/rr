module RR
  module Integrations
    class TestUnit200ActiveSupport
      def initialize
        @mt4as_adapter = MiniTest4ActiveSupport.new
        @tu200_adapter = TestUnit200.new
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
  end
end
