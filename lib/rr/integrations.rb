module RR
  module Integrations
    def self.build(name)
      const_get(name).new
    end
  end
end
