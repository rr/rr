module RR
  class << self
    ADAPTER_NAMES = [
      :RSpec1,
      :RSpec2,
      :TestUnit1,
      :TestUnit2ActiveSupport,
      :TestUnit2,
      :MiniTestActiveSupport,
      :MiniTest
    ]

    def autohook
      find_applicable_adapters.each do |adapter|
        #puts "Using adapter: #{adapter.name}"
        adapter.hook
      end
    end

    def adapters
      @adapters ||= ADAPTER_NAMES.map { |adapter_name|
        [adapter_name, RR::Adapters.const_get(adapter_name).new]
      }
    end

    def find_applicable_adapters
      @applicable_adapters ||= begin
        applicable_adapters = adapters.inject([]) { |arr, (_, adapter)|
          arr << adapter if adapter.applies?
          arr
        }
        if applicable_adapters.empty?
          applicable_adapters << adapters.index(:None)
        end
        applicable_adapters
      end
    end
  end
end

RR.autohook
