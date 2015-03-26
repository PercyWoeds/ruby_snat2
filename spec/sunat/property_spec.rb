require 'spec_helper'

describe SUNAT::Property do

  let :owner do
    double()
  end

  let :submodel do
    Class.new do
      include SUNAT::Model
      property :name, String
    end
  end

  describe "#initialize" do

    it "should copy name and type" do
      prop = SUNAT::Property.new("name", String)
      expect(prop.name).to eql(:name)
      expect(prop.type).to eql(String)
      expect(prop.use_casted_array?).to be false
    end

    it "should convert Array to CastedArray type" do
      prop = SUNAT::Property.new("names", [String])
      expect(prop.name).to eql(:names)
      expect(prop.type).to eql(String)
      expect(prop.use_casted_array?).to be true
    end

    it "should accept a default option" do
      prop = SUNAT::Property.new(:name, String, :default => "Freddo")
      expect(prop.default).to eql("Freddo")
    end

  end

  describe "#to_s" do
    it "should use property's name" do
      prop = SUNAT::Property.new(:name, String)
      expect(prop.to_s).to eql("name")
    end
  end

  describe "#to_sym" do
    it "should return the name" do
      prop = SUNAT::Property.new(:name, String)
      expect(prop.to_sym).to eql (:name)
    end
  end

  describe "#cast" do
    context "without an array" do
      it "should build a new object" do
        prop = SUNAT::Property.new(:date, Time)
        obj = prop.cast(owner, "2013-06-02T12:00:00")
        expect(obj.class).to eql(Time)
        expect(obj).to eql(Time.new("2013-06-02T12:00:00"))
      end

      it "should assign casted by and property" do
        prop = SUNAT::Property.new(:item, submodel)
        obj = prop.cast(owner, {:name => 'test'})
        expect(obj.casted_by).to eql(owner)
        expect(obj.casted_by_property).to eql(prop)
      end
    end

    context "with an array" do
      it "should convert regular array to casted array" do
        prop = SUNAT::Property.new(:dates, [Time])
        obj = prop.cast(owner, ["2013-06-02T12:00:00"])
        expect(obj.class).to eql(SUNAT::CastedArray)
        expect(obj.first.class).to eql(Time)
      end
      it "should handle complex objects" do
        prop = SUNAT::Property.new(:items, [submodel])
        obj = prop.cast(owner, [{:name => 'test'}])
        expect(obj.class).to eql(SUNAT::CastedArray)
        expect(obj.first.class).to eql(submodel)
        expect(obj.first.name).to eql('test')
      end
    end
  end


end
