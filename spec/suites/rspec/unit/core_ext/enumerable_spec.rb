require File.expand_path('../../../spec_helper', __FILE__)

describe Enumerable do
  include WildcardMatcherMatchers

  let(:klass) {
    Class.new do
      include Enumerable

      def initialize(*items)
        @arr = items
      end

      def each(&block)
        @arr.each(&block)
      end
    end
  }

  describe '#wildcard_match?' do
    context 'when this Enumerable has items that respond to #wildcard_match?' do
      subject { klass.new(hash_including({:foo => 'bar'})) }

      it "returns true if all items in the given Enumerable wildcard-match corresponding items in this Enumerable" do
        should wildcard_match([{:foo => 'bar', :baz => 'quux'}])
      end

      it "returns true if any items in the given Enumerable do not wildcard-match corresponding items in this Enumerable" do
        should_not wildcard_match([{:foo => 'bat', :baz => 'quux'}])
      end
    end

    context 'when this Enumerable has items that do not respond to #wildcard_match?' do
      subject { klass.new(:a_symbol) }

      it "returns true if all items in the given Enumerable equal-match corresponding items in this Enumerable" do
        should wildcard_match([:a_symbol])
      end

      it "returns true if any items in the given Enumerable do not equal-match corresponding items in this Enumerable" do
        should_not wildcard_match([:another_symbol])
      end
    end

    context 'when not given an Enumerable' do
      subject { klass.new({:foo => 'bar'}) }

      it "returns false" do
        should_not wildcard_match(:something_else)
      end
    end
  end
end
