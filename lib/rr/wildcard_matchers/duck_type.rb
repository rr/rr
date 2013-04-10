module RR
  module WildcardMatchers
    class DuckType
      attr_accessor :required_methods

      def initialize(*required_methods)
        @required_methods = required_methods
      end

      def wildcard_match?(other)
        self == other ||
        required_methods.all? {|m| other.respond_to?(m) }
      end

      def ==(other)
        other.is_a?(self.class) &&
        other.required_methods == self.required_methods
      end
      alias :eql? :==

      def inspect
        formatted_required_methods =
          required_methods.map { |method_name| method_name.inspect }.join(', ')
        "duck_type(#{formatted_required_methods})"
      end
    end
  end
end
