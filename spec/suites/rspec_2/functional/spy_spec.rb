require File.expand_path('../../spec_helper', __FILE__)

describe 'spy' do
  it "records invocations of most methods on a given object" do
    subject = String.new
    def subject.some_method; end

    spy(subject)

    subject.some_method
    subject.reverse
    subject.to_s

    subject.should have_received.some_method
    subject.should have_received.reverse
    subject.should have_received.to_s
  end

  it "excludes #methods from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.methods
    subject.should_not have_received.methods
  end

  it "excludes #== from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject == 5
    subject.should_not have_received(:==)
  end

  it "excludes #__send__ from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.__send__('to_s')
    subject.should_not have_received(:__send__)
  end

  it "excludes #__id__ from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.__id__
    subject.should_not have_received(:__id__)
  end

  it "excludes #object_id from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.object_id
    subject.should_not have_received(:object_id)
  end

  it "excludes #class from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.class
    subject.should_not have_received.class
  end

  it "excludes #respond_to? from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.respond_to?(:foo)
    subject.should_not have_received(:respond_to?)
  end

  it "excludes #methods from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.methods
    subject.should_not have_received.methods
  end

  it "excludes #== from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject == 5
    subject.should_not have_received(:==)
  end

  it "excludes #__send__ from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.__send__('to_s')
    subject.should_not have_received(:__send__)
  end

  it "excludes #__id__ from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.__id__
    subject.should_not have_received(:__id__)
  end

  it "excludes #object_id from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.object_id
    subject.should_not have_received(:object_id)
  end

  it "excludes #class from the list of recorded methods" do
    subject = Object.new
    spy(subject)
    subject.class
    subject.should_not have_received.class
  end
end
