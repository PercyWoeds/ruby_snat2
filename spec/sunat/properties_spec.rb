require 'spec_helper'

describe SUNAT::Properties do
  
  before :all do
    @aux_model = Class.new do
      include SUNAT::Model
      property :age, Fixnum
    end
    Kernel.const_set("Aux", @aux_model)
  end

  before :each do
    @model = Class.new do
      include SUNAT::Model
      property :name, String
    end
    
    @obj = @model.new
  end


  describe "#get_attribute" do
    it "should provide object in model" do
      @obj[:key1] = 'value'
      expect(@obj.get_attribute(:key1)).to eql('value')
    end
  end

  describe "#set_attribute" do
    it "should be posible to set attribute not defined as property" do
      @obj.set_attribute('key1', 'value1')
      @obj.set_attribute(:key2, 'value2')
      expect(@obj[:key1]).to eql('value1')
      expect(@obj[:key2]).to eql('value2')
    end

    it "should set and cast attribute with property" do
      property = @model.send(:properties)[:name]
      name = "Fred Flinstone"
      expect(property).to receive(:cast).with(@obj, name).and_return(name)
      @obj.set_attribute(:name, name)
      expect(@obj[:name]).to eql(name)
    end
  end

  describe ".properties" do

    it "should be instantiated after property set" do
      expect(@model.properties).to_not be_nil
      expect(@model.properties.class).to eql(Hash)
    end

    it "should be null if no properties" do
      model = Class.new do
        include SUNAT::Model
      end
      expect(model.properties).to be_nil
    end

  end

  describe ".property" do

    it "should fail if no type is defined" do
      expect(@model.properties.length).to eql(1)
      expect {
        @model.property :foobar
      }.to raise_error(ArgumentError)
      expect(@model.properties.length).to eql(1)
    end

    it "should create a new property with helper methods" do
      expect(@model.properties.length).to eql(1)
      @model.property :desc, String
      expect(@model.properties.length).to eql(2)

      prop = @model.properties[:desc]
      expect(prop.class).to eql(SUNAT::Property)

      expect(@obj).to respond_to(:desc)
      expect(@obj).to respond_to(:desc=)

      @obj.desc = "test"
      expect(@obj.desc).to eql("test")
    end
    
    it "should return nil on property with no default" do
      @model.property :nickname, String
      expect(@obj.nickname).to be_nil
    end

    it "should create helper method with support for default values" do
      @model.property :name, String, :default => "Sam"
      expect(@obj.name).to eql("Sam")
    end

  end


end
