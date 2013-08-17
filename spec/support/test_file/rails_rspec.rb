require File.expand_path('../rspec', __FILE__)

module TestFile
  module RailsRSpec
    include RSpec

    # Don't require anything; this will happen in the spec helper
    def all_requires
      []
    end
  end
end
