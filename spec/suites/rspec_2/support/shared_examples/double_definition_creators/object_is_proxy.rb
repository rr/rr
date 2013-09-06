# btakita/rr issue #24
# this happens when defining a double on an ActiveRecord association object
shared_examples_for 'defining a method double on an object which is a proxy for another object' do
  include DoubleDefinitionCreatorHelpers

  it "places the double on the proxy object and not the target object by mistake" do
    target_object = build_object_with_possible_methods(some_method: -> { 'existing value' })
    proxy_object = proxy_object_class.new(target_object)
    expect(proxy_object.methods).to match_array(target_object.methods)
    double_definition_creator_for(proxy_object).some_method { 'value' }
    expect(proxy_object.some_method).to eq 'value'
  end

  it "resets the double correctly" do
    target_object = build_object_with_possible_methods(some_method: -> { 'existing value' })
    proxy_object = proxy_object_class.new(target_object)
    expect(proxy_object.methods).to match_array(target_object.methods)
    double_definition_creator_for(proxy_object).some_method { 'value' }
    RR.reset
    expect_method_to_have_value_or_be_absent('existing value', proxy_object, :some_method)
  end

  def proxy_object_class
    Class.new do
      # This matches what AssociationProxy was like as of Rails 2
      instance_methods.each do |m|
        undef_method m unless m.to_s =~ /^(?:nil\?|send|object_id|to_a)$|^__|^respond_to|proxy_/
      end

      def initialize(target)
        @target = target
      end

      def method_missing(name, *args, &block)
        if @target.respond_to?(name)
          @target.__send__(name, *args, &block)
        else
          super
        end
      end
    end
  end
end
