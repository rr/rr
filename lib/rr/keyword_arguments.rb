module RR
  module KeywordArguments
    class << self
      if (RUBY_VERSION <=> "3.0.0") >= 0
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
