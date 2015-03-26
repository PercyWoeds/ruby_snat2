require 'spec_helper'

describe SUNAT::Receipt do
  include ValidationSpecHelpers
  include SupportingSpecHelpers
  
  let :receipt do
    SUNAT::Receipt.new
  end
  
  describe "#initialize" do
    it "should begin with the correct DOCUMENT_TYPE_CODE" do
      receipt.invoice_type_code.should == SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end
    
    it "should begin with a document_currency_code by default" do
      receipt.document_currency_code.should_not be_nil
    end
  end
end