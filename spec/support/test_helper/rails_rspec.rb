require File.expand_path('../rails', __FILE__)

module TestHelper
  module RailsRSpec
    include Rails

    def path
      File.join(project.directory, 'spec/spec_helper.rb')
    end

    def start_of_requires
      if project.rails_version == 2
        Regexp.new(Regexp.escape(%q!require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))!))
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
