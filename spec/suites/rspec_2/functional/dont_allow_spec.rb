require File.expand_path('../../spec_helper', __FILE__)

describe '#dont_allow' do
  subject { Object.new }

  it "raises a TimesCalledError if the method is actually called" do
    dont_allow(subject).foobar
    expect {
      subject.foobar
    }.to raise_error(RR::Errors::TimesCalledError)
  end
end
