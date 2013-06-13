module RR
  module Integrations
    class MinitestActiveSupport < MiniTest4ActiveSupport
      def parent_adapter_class
        Minitest
      end

      def name
        'Minitest + ActiveSupport'
      end
    end

    RR.register_adapter MinitestActiveSupport
  end
end
