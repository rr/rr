require File.expand_path('../test_unit', __FILE__)
require File.expand_path('../rails', __FILE__)

module TestHelper
  module RailsTestUnit
    include TestUnit
    include Rails

    def start_of_requires
      if project.rails_version == 2
        Regexp.new(Regexp.escape('require File.expand_path(File.dirname(__FILE__) + "/../config/environment")'))
      else
        Regexp.new(
          Regexp.escape('require File.expand_path(') +
          %q/(?:"|')/ +
          Regexp.escape('../../config/environment') +
          %q/(?:"|')/ +
          Regexp.escape(', __FILE__)')
        )
      end
    end
  end
end
