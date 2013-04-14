module RR
  class << self
    attr_accessor :overridden_error_class
  end

  module Errors
    def self.build_error(given_error, message = nil, backtrace = nil)
      error_class = self.error_class(given_error)
      error = message ? error_class.new(message) : error_class.new
      error.backtrace = backtrace if error_class < RR::Errors::RRError
      error
    end

    def self.error_class(given_error)
      RR.overridden_error_class ||
      (given_error.is_a?(Symbol) ?
        RR::Errors.const_get(given_error) :
        given_error)
    end
  end
end
