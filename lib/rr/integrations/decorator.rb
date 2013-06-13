require 'delegate'

module RR
  module Integrations
    class Decorator < SimpleDelegator
      def initialize(adapter)
        super(adapter)
        @loaded = false
      end

      def name
        __getobj__.class.to_s.split('::').last.to_sym
      end

      def load
        hook
        @loaded = true
        puts "Loaded adapter: #{name}" if RR.debug?
      rescue => e
        if RR.debug?
          puts "Couldn't load adapter #{name}: #{e.class} (#{e.message})"
        end
        raise e
      end

      def loaded?
        @loaded
      end
    end
  end
end
