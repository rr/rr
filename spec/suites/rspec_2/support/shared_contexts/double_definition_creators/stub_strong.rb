shared_context 'stub + strong' do
  include StubDefinitionCreatorHelpers

  context 'against instance methods', method_type: :instance do
    context 'that exist', methods_exist: true do
      include_context 'tests for a double definition creator method that supports stubbing'

      it_behaves_like 'comparing the arity between the method and double definition'
    end

    context 'that do not exist', methods_exist: false do
      it "doesn't work" do
        object = Object.new
        double_creator = double_definition_creator_for(object)
        expect { double_creator.some_method }.to \
          raise_error(RR::Errors::SubjectDoesNotImplementMethodError)
      end
    end
  end

  context 'against class methods', method_type: :class do
    context 'that exist', methods_exist: true do
      include_context 'tests for a double definition creator method that supports stubbing'

      it_behaves_like 'comparing the arity between the method and double definition'
    end

    context 'that do not exist', methods_exist: false do
      it "doesn't work" do
        klass = Class.new
        double_creator = double_definition_creator_for(klass)
        expect { double_creator.some_method }.to \
          raise_error(RR::Errors::SubjectDoesNotImplementMethodError)
      end
    end
  end
end
