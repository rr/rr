require File.expand_path('../../spec_helper', __FILE__)

describe 'stub!' do
  it "is a terser way of creating an object and stubbing it" do
    object = stub!.some_method { 'value' }.subject
    expect(object.some_method).to eq 'value'
  end

  it "can be used inside the implementation block of a double" do
    object = Object.new
    stub(object).some_method { stub!.another_method { 'value' } }
    expect(object.some_method.another_method).to eq 'value'
  end

  it "can be called on a double" do
    object = Object.new
    stub(object).some_method.stub!.another_method { 'value' }
    expect(object.some_method.another_method).to eq 'value'
  end
end
