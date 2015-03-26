require 'spec_helper'

describe SUNAT::CastedArray do

  let :owner do
    double()
  end

  describe "#initialize" do
    before :each do
      @prop = SUNAT::Property.new(:name, String)
      @obj = SUNAT::CastedArray.new(owner, @prop, ['test'])
    end

    it "should prepare array" do
      expect(@obj.length).to eql(1)
    end

    it "should set owner and property" do
      expect(@obj.casted_by).to eql(owner)
      expect(@obj.casted_by_property).to eql(@prop)
    end

    it "should instantiate and cast each value" do
      expect(@obj.first).to eql("test")
      expect(@obj.first.class).to eql(String)
    end
  end

  describe "adding to array" do
    
    let :submodel do
      Class.new do
        include SUNAT::Model
        property :name, String
      end
    end
    
    before :each do
      @prop = SUNAT::Property.new(:item, submodel)
      @obj = SUNAT::CastedArray.new(owner, @prop, [{:name => 'test'}])
    end

    it "should cast new items" do
      @obj << {:name => 'test2'}
      expect(@obj.last.class).to eql(submodel)
      expect(@obj.first.name).to eql('test')
      expect(@obj.last.name).to eql('test2')

      expect(@obj.last.casted_by).to eql(owner)
     expect( @obj.last.casted_by_property).to eql(@prop)
    end

  end

end
