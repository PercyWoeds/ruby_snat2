require 'spec_helper'

describe SUNAT::PaymentAmount do
  describe ".new" do
    it "should handle a string" do
      amount = SUNAT::PaymentAmount.new("12345")
      expect(amount.value).to eql(12345)
      expect(amount.currency).to eql("PEN")
    end
    it "should handle an integer" do
      amount = SUNAT::PaymentAmount.new(123457)
      expect(amount.value).to eql(123457)
      expect(amount.currency).to eql("PEN")
    end
    it "should handle a hash" do
      amount = SUNAT::PaymentAmount.new(:value => 123456)
      expect(amount.value).to eql(123456)
      expect(amount.currency).to eql("PEN")
    end
  end

  describe "#[]" do    
    it "should be a pretty factory" do
      amount = SUNAT::PaymentAmount[117350, "PEN"]
      expect(amount.currency).to eql "PEN"
      expect(amount.value).to eql 117350
    end

    it "should accept amount without currency" do
      amount = SUNAT::PaymentAmount[11289]
      expect(amount.currency).to eql('PEN')
      expect(amount.value).to eql(11289)
    end
  end
  
  describe 'to_s' do
    it "should print a string" do
      expect(SUNAT::PaymentAmount[117350, "PEN"].to_s).to eql '1173.50'
    end

    it "should print lower than 10 cent values with a 0 first" do
      expect(SUNAT::PaymentAmount[117305, "PEN"].to_s).to eql '1173.05'
    end 
  end
end
