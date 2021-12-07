module RR
  module KeywordArguments
    class << self
      if (RUBY_VERSION <=> "3.0.0") >= 0 and RUBY_ENGINE != "truffleruby"
        def fully_supported?
          true
        end
      else
        def fully_supported?
          false
        end
      end
    end
  end
end
