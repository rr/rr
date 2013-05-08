require File.expand_path('../../spec_helper', __FILE__)

%w(instance_of all_instances_of).each do |method|
  describe "##{method}" do
    it "applies to instances instantiated before the Double expection was created" do
      subject_class = Class.new
      subject = subject_class.new
      __send__(method, subject_class) do |o|
        o.to_s {"Subject is stubbed"}
      end
      expect(subject.to_s).to eq "Subject is stubbed"
    end
  end
end
