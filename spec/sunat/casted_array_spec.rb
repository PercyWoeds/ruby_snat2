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
      @obj.length.should eql(1)
    end

    it "should set owner and property" do
      @obj.casted_by.should eql(owner)
      @obj.casted_by_property.should eql(@prop)
    end

    it "should instantiate and cast each value" do
      @obj.first.should eql("test")
      @obj.first.class.should eql(String)
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
      @obj.last.class.should eql(submodel)
      @obj.first.name.should eql('test')
      @obj.last.name.should eql('test2')

      @obj.last.casted_by.should eql(owner)
      @obj.last.casted_by_property.should eql(@prop)
    end

  end

end
