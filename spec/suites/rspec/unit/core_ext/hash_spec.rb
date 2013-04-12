require File.expand_path('../../../spec_helper', __FILE__)

describe Hash do
  include WildcardMatcherMatchers

  describe '#wildcard_match?' do
    context 'when this Hash has keys that respond to #wildcard_match?' do
      subject { {is_a(Symbol) => 'x'} }

      it "returns true if all keys in the given Hash wildcard-match the corresponding keys in this Hash" do
        should wildcard_match({:foo => 'x'})
      end

      it "returns true if any keys in the given Hash do not wildcard-match the corresponding keys in this Hash" do
        should_not wildcard_match({'foo' => 'x'})
      end
    end

    context 'when this Hash has values that respond to #wildcard_match?' do
      subject { {'x' => is_a(Symbol)} }

      it "returns true if all values in the given Hash wildcard-match the corresponding values in this Hash" do
        should wildcard_match({'x' => :foo})
      end

      it "returns false if any values in the given Hash do not wildcard-match the corresponding values in this Hash" do
        should_not wildcard_match({'x' => 'foo'})
      end
    end

    context 'when this Hash does not have keys or values that respond to #wildcard_match?' do
      subject { {:x => :y} }

      it "returns true if all pairs in the given Hash wildcard-match the corresponding values in this Hash" do
        should wildcard_match({:x => :y})
      end

      it "returns false if any keys do not equal-match corresponding items in the subject" do
        should_not wildcard_match({:z => :y})
      end

      it "returns false if any values do not equal-match corresponding items in the subject" do
        should_not wildcard_match({:x => :z})
      end
    end

    context 'when not given a Hash' do
      subject { {:foo => 'bar'} }

      it "returns false" do
        should_not wildcard_match(:something_else)
      end
    end
  end
end
