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

    if RUBY_VERSION =~ /^1.8/
      context 'when the Enumerable is a String' do
        subject { 'foo' }

        it "returns true if the String is exactly equal to the given String" do
          should wildcard_match('foo')
        end

        it "returns false if the string is not exactly equal to the given String" do
          should_not wildcard_match('bar')
        end

        context 'whose #== method has been proxied' do
          before do
            @r1 = 'x'
            @r2 = 'y'
            mock.proxy(@r1) == @r1
            mock.proxy(@r1) == @r2
          end

          it "doesn't blow up with a recursive loop error" do
            @r1 == @r1
            @r1 == @r2
          end
        end
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
