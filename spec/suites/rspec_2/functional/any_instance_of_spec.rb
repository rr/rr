require File.expand_path('../../spec_helper', __FILE__)

describe 'any_instance_of' do
  context 'stubs for instance methods of a class' do
    context 'via block form' do
      context 'for existing methods' do
        it "can be defined" do
          a_class = Class.new { def some_method; 'value'; end }
          any_instance_of(a_class) { |c| stub(c).some_method { 'value' } }
          instance = a_class.new
          expect(instance.some_method).to eq 'value'
        end

        it "can be reset" do
          a_class = Class.new { def some_method; 'original value'; end }
          any_instance_of(a_class) { |c| stub(c).some_method { 'value' } }
          RR.reset
          instance = a_class.new
          expect(instance.some_method).to eq 'original value'
        end
      end

      context 'for non-existing methods' do
        it "can be defined" do
          a_class = Class.new
          any_instance_of(a_class) { |c| stub(c).some_method { 'value' } }
          instance = a_class.new
          expect(instance.some_method).to eq 'value'
        end

        it "can be reset" do
          a_class = Class.new
          any_instance_of(a_class) { |c| stub(c).some_method { 'value' } }
          RR.reset
          instance = a_class.new
          expect(instance).not_to respond_to(:some_method)
        end
      end
    end

    context 'via hash form' do
      context 'for existing methods' do
        it "can be defined" do
          a_class = Class.new { def some_method; 'value'; end }
          any_instance_of(a_class, :some_method => lambda { 'value' })
          instance = a_class.new
          expect(instance.some_method).to eq 'value'
        end

        it "can be reset" do
          a_class = Class.new { def some_method; 'original value'; end }
          any_instance_of(a_class, :some_method => lambda { 'value' })
          RR.reset
          instance = a_class.new
          expect(instance.some_method).to eq 'original value'
        end
      end

      context 'for non-existing methods' do
        it "can be defined" do
          a_class = Class.new
          any_instance_of(a_class, :some_method => lambda { 'value' })
          instance = a_class.new
          expect(instance.some_method).to eq 'value'
        end

        it "can be reset" do
          a_class = Class.new
          any_instance_of(a_class, :some_method => lambda { 'value' })
          RR.reset
          instance = a_class.new
          expect(instance).not_to respond_to(:some_method)
        end
      end
    end
  end

  context 'stub-proxies for instance methods of a class' do
    it "can be defined" do
      a_class = Class.new { def some_method; 'value'; end }
      any_instance_of(a_class) { |c| stub.proxy(c).some_method { 'value' } }
      instance = a_class.new
      expect(instance.some_method).to eq 'value'
    end

    it "can be reset" do
      a_class = Class.new { def some_method; 'original value'; end }
      any_instance_of(a_class) { |c| stub.proxy(c).some_method { 'value' } }
      RR.reset
      instance = a_class.new
      expect(instance.some_method).to eq 'original value'
    end
  end

  context 'mocks for instance methods of a class' do
    context 'for existing methods' do
      it "can be defined" do
        a_class = Class.new { def some_method; 'value'; end }
        any_instance_of(a_class) { |c| mock(c).some_method { 'value' } }
        instance = a_class.new
        expect(instance.some_method).to eq 'value'
      end

      it "can be reset" do
        a_class = Class.new { def some_method; 'original value'; end }
        any_instance_of(a_class) { |c| mock(c).some_method { 'value' } }
        RR.reset
        instance = a_class.new
        expect(instance.some_method).to eq 'original value'
      end
    end

    context 'for non-existing methods' do
      it "can be defined" do
        a_class = Class.new
        any_instance_of(a_class) { |c| mock(c).some_method { 'value' } }
        instance = a_class.new
        expect(instance.some_method).to eq 'value'
      end

      it "can be reset" do
        a_class = Class.new
        any_instance_of(a_class) { |c| mock(c).some_method { 'value' } }
        RR.reset
        instance = a_class.new
        expect(instance).not_to respond_to(:some_method)
      end
    end
  end

  context 'mock-proxies for instance methods of a class' do
    it "can be defined" do
      a_class = Class.new { def some_method; 'value'; end }
      any_instance_of(a_class) { |c| mock.proxy(c).some_method { 'value' } }
      instance = a_class.new
      expect(instance.some_method).to eq 'value'
    end

    it "can be reset" do
      a_class = Class.new { def some_method; 'original value'; end }
      any_instance_of(a_class) { |c| mock.proxy(c).some_method { 'value' } }
      RR.reset
      instance = a_class.new
      expect(instance.some_method).to eq 'original value'
    end
  end
end
