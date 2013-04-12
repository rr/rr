require File.expand_path('../../../spec_helper', __FILE__)

describe Array do
  include WildcardMatcherMatchers

  describe '#wildcard_match?' do
    context 'when this Array has items that respond to #wildcard_match?' do
      subject { [hash_including({:foo => 'bar'})] }

      it "returns true if all items in the given Array wildcard-match corresponding items in this Array" do
        should wildcard_match([{:foo => 'bar', :baz => 'quux'}])
      end

      it "returns true if any items in the given Array do not wildcard-match corresponding items in this Array" do
        should_not wildcard_match([{:foo => 'bat', :baz => 'quux'}])
      end
    end

    context 'when this Array has items that do not respond to #wildcard_match?' do
      subject { [:a_symbol] }

      it "returns true if all items in the given Array equal-match corresponding items in this Array" do
        should wildcard_match([:a_symbol])
      end

      it "returns true if any items in the given Array do not equal-match corresponding items in this Array" do
        should_not wildcard_match([:another_symbol])
      end
    end

    context 'when not given an Array' do
      subject { [{:foo => 'bar'}] }

      it "returns false" do
        should_not wildcard_match(:something_else)
      end
    end
  end
end
