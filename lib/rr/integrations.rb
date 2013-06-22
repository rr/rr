require 'set'

module RR
  module Integrations
  end

  def self.register_adapter(klass)
    adapter = Integrations::Decorator.new(klass.new)
    unless adapters_by_name.key?(adapter.name)
      adapters << adapter
      adapters_by_name[adapter.name] = adapter
    end
  end

  def self.adapters
    @adapters ||= []
  end

  def self.adapters_by_name
    @adapters_by_name ||= {}
  end

  def self.loaded_adapter_names
    adapters.
      select { |adapter| adapter.loaded? }.
      map { |adapter| adapter.name }
  end

  def self.applicable_adapters
    adapters.select { |adapter| adapter.applies? }
  end

  def self.find_applicable_adapter(name)
    adapters.
      select { |adapter| name === adapter.name.to_s }.
      find   { |adapter| adapter.applies? }
  end

  def self.module_shim_for_adapter(adapter)
    mod = Module.new
    (class << mod; self; end).class_eval do
      define_method(:included) do |base|
        # Note: This assumes that the thing that is including this module
        # is the same that the adapter detected and will hook into.
        adapter.load
      end
    end
    mod
  end
end
