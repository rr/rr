module RR
  module KeywordArguments
    class << self
      if (RUBY_VERSION <=> "2.7.0") >= 0
        def fully_supported?
          true
        end
      else
        def fully_supported?
          false
        end
      end

      def accept_kwargs?(subject_class, method_name)
        subject_class.instance_method(method_name).parameters.any? { |t, _| t == :key || t == :keyrest }
      rescue NameError
        true
      end
    end
  end
end
