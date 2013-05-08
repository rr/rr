require File.expand_path('../../spec_helper', __FILE__)

describe '#spy' do
  subject { Object.new }

  it "should record all method invocations" do
    subject = Object.new

    def subject.something
    end

    def subject.something_else
    end

    spy(subject)

    subject.something
    subject.something_else
    subject.to_s

    received(subject).something.call
    received(subject).something_else.call
    received(subject).to_s.call
  end

  describe "RR recorded_calls" do
    it "should verify method calls after the fact" do
      stub(subject).pig_rabbit
      subject.pig_rabbit("bacon", "bunny meat")
      #expect(subject).to have_received.pig_rabitt("bacon", "bunny meat")
      received(subject).pig_rabbit("bacon", "bunny meat").call
    end

    it "should verify method calls after the fact" do
      stub(subject).pig_rabbit
      expect {
        received(subject).pig_rabbit("bacon", "bunny meat").call
      }.to raise_error(RR::Errors::SpyVerificationErrors::SpyVerificationError)
    end
  end
end
