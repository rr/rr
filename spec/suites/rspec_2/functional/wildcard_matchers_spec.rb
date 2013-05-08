require File.expand_path('../../spec_helper', __FILE__)
require 'ostruct'

describe 'wildcard matchers' do
  subject { Object.new }

  describe '#anything' do
    it "works outside a container" do
      mock(subject).foo(anything)
      subject.foo(:whatever)
    end

    it "works within a container too" do
      mock(subject).foo([anything])
      subject.foo([:whatever])
    end
  end

  describe '#boolean' do
    it "works outside a container" do
      mock(subject).foo(boolean)
      subject.foo(false)
    end

    it "works within a container too" do
      mock(subject).foo([boolean])
      subject.foo([false])
    end
  end

  describe '#duck_type' do
    it "works outside a container" do
      mock(subject).foo(duck_type(:bar))
      subject.foo(OpenStruct.new(:bar => 3))
    end

    it "works within a container too" do
      mock(subject).foo([duck_type(:bar)])
      subject.foo([OpenStruct.new(:bar => 3)])
    end
  end

  describe '#hash_including' do
    it "works outside a container" do
      mock(subject).foo(hash_including(:c => 'd'))
      subject.foo(:a => 'b', :c => 'd')
    end

    it "works within a container too" do
      mock(subject).foo([hash_including(:c => 'd')])
      subject.foo([{:a => 'b', :c => 'd'}])
    end
  end

  describe '#is_a' do
    context 'when outside a container' do
      it "matches a simple value" do
        mock(subject).foo(is_a(Symbol))
        subject.foo(:symbol)
      end

      it "matches a container value" do
        mock(subject).foo(is_a(Array))
        subject.foo(['x', 'y'])
      end
    end

    context 'within a container' do
      it "matches a simple value" do
        mock(subject).foo([is_a(Symbol)])
        subject.foo([:symbol])
      end

      it "matches a container" do
        mock(subject).foo([is_a(Hash)])
        subject.foo([{:x => 'y'}])
      end
    end
  end

  describe '#numeric' do
    it "works outside a container" do
      mock(subject).foo(numeric)
      subject.foo(3)
    end

    it "works within a container too" do
      mock(subject).foo([numeric])
      subject.foo([3])
    end
  end

  describe 'range' do
    it "works outside a container" do
      mock(subject).foo(1..5)
      subject.foo(3)
    end

    it "works within a container too" do
      mock(subject).foo([1..5])
      subject.foo([3])
    end
  end

  describe 'regexp' do
    it "works outside a container" do
      mock(subject).foo(/foo/)
      subject.foo('foobar')
    end

    it "works within a container too" do
      mock(subject).foo([/foo/])
      subject.foo(['foobar'])
    end
  end

  describe '#satisfy' do
    it "works outside a container" do
      mock(subject).foo(satisfy {|x| x == 'x' })
      subject.foo('x')
    end

    it "works within a container too" do
      mock(subject).foo([satisfy {|x| x == 'x' }])
      subject.foo(['x'])
    end
  end
end
