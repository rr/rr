module RR
  class << self
    ADAPTER_NAMES = [
      :RSpec1,
      :RSpec2,
      :TestUnit1,
      :TestUnit2ActiveSupport,
      :TestUnit2,
      :MiniTest4ActiveSupport,
      :MiniTest4,
      :MinitestActiveSupport,
      :Minitest
    ]

    def autohook
      applicable_adapters.each do |adapter|
        #puts "Using adapter: #{adapter.name}"
        adapter.hook
      end
    end

    private

    def adapters
      @adapters ||= ADAPTER_NAMES.map { |adapter_name|
        [adapter_name, RR::Integrations.build(adapter_name)]
      }
    end

    def applicable_adapters
      @applicable_adapters ||= adapters.
        map { |_, adapter| adapter }.
        select { |adapter| adapter.applies? }
    end
  end
end

RR.autohook
