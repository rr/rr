require File.expand_path('../../spec_helper', __FILE__)

describe 'received' do
  it "doesn't throw an error if the invocation occurred" do
    stub(subject).pig_rabbit
    subject.pig_rabbit('bacon', 'bunny meat')
    received(subject).pig_rabbit('bacon', 'bunny meat').call
  end

  it "throws a SpyVerificationError if the invocation did not occur" do
    stub(subject).pig_rabbit
    expect {
      received(subject).pig_rabbit('bacon', 'bunny meat').call
    }.to raise_error(RR::Errors::SpyVerificationErrors::SpyVerificationError)
  end
end
