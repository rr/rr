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

      def applies?
        __getobj__.applies?
      rescue => e
        if RR.debug?
          puts "#{__getobj__.class}#applies? failed: #{e.class} (#{e.message})"
          puts e.backtrace.map {|x| "  " + x }.join("\n")
        end
      end

      def load
        return if @loaded
        hook
        if RR.debug?
          puts "Loaded adapter: #{name}"
        end
        @loaded = true
      rescue => e
        if RR.debug?
          puts "Couldn't load adapter #{name}: #{e.class} (#{e.message})"
          puts e.backtrace.map {|x| "  " + x }.join("\n")
        end
      end

      def loaded?
        @loaded
      end
    end
  end
end
