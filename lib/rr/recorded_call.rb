module RR
  class RecordedCall < Struct.new(:subject,
                                  :method_name,
                                  :arguments,
                                  :keyword_arguments,
                                  :block)
    def inspect
      '[%s, %s, %s, %s, %s]' % [
        subject_to_s,
        method_name.inspect,
        arguments.inspect,
        keyword_arguments.inspect,
        block.inspect
      ]
    end

    def ==(other)
      other.is_a?(self.class) &&
        subject == other.subject &&
        method_name == other.method_name &&
        arguments == other.arguments &&
        keyword_arguments == other.keyword_arguments
    end

    private

    def subject_to_s
      if subject.respond_to?(:__rr__original_to_s, true)
        subject.__rr__original_to_s
      else
        subject.to_s
      end
    end
  end
end
