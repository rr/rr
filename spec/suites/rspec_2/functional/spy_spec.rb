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
end
