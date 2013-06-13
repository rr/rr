module RR
  module Integrations
    class TestUnit200
      def initialize
        @mt4_adapter = RR.adapters_by_name[:MiniTest4]
        @tu_adapter = RR.adapters_by_name[:TestUnit1]
      end

      def name
        'Test::Unit 2.0.0'
      end

      def applies?
        @mt4_adapter.applies? &&
        defined?(::Test::Unit) &&
        !@tu_adapter.has_test_unit_version? &&
        @tu_adapter.test_unit_just_wraps_minitest?
      end

      def hook
        @mt4_adapter.hook
      end
    end

    RR.register_adapter TestUnit200
  end
end
