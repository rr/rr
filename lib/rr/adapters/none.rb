module RR
  module Adapters
    class None
      def name
        'No adapter'
      end

      def applies?
        true
      end

      def hook
        raise "RR: no applicable adapter could be found! Have you required a test framework?"
      end
    end
  end

  add_adapter :None
end
