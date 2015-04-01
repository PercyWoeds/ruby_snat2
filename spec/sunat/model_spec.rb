require 'spec_helper'

describe SUNAT::Model do
  
  class TestModel
    include SUNAT::Model
    property :name, String
    property :not_required, String

    validates :name, presence: true
  end

  before :each do
    @model = TestModel
  end
  
  describe '.build' do
    it "should create a Model and give a block to build it" do
      expect(TestModel).to receive(:call_in_block)
      @model.build do |model|
        TestModel.call_in_block
        expect(model).to be_kind_of(TestModel)
      end
    end
  end

  describe "#initialize" do

    it "should accept nil" do
      expect {
        @obj = TestModel.new
      }.to_not raise_error
    end

    it "should accept and set attributes" do
      @obj = TestModel.new(:name => "Sam")
      expect(@obj.name).to eql("Sam")
    end

  end

  describe "validations" do
    it "should run the class validations" do
      expect(TestModel.new.valid?).to be false
      expect(TestModel.new(name: "Name").valid?).to be true
    end

    it "should run the class validations for the properties included" do
      class NestedModel
        include SUNAT::Model

        property :nested, TestModel
      end
      expect(NestedModel.new(nested: {not_required: "value"}).valid?).to be false
      
      expect(NestedModel.new(nested: {name: "value"}).valid?).to be true

    end

    it "should run the class validations for all the elements when the property is an Array" do
      class NestedModel
        include SUNAT::Model

        property :nested, [TestModel]
      end
      
      valid_test_model = {name: "value"}
      invalid_test_model = {not_required: "value"}

      expect(NestedModel.new(nested: [valid_test_model, invalid_test_model]).valid?).to be false
      
      expect(NestedModel.new(nested: [valid_test_model]).valid?).to be true

    end

  end

end

