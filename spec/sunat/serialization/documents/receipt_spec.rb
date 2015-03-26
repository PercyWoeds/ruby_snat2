require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of a receipt' do
  include SupportingSpecHelpers
  
  context 'with accounting_customer_party' do
    before :all do
      @receipt = eval_support_script("serialization/receipt_sample")
      @xml = Nokogiri::XML(@receipt.to_xml)
    end
  
    it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
      date = @xml.xpath("//cbc:IssueDate")
      date.count.should >= 0
      date.text.should eq(Date.today.strftime("%Y-%m-%d"))
    end
  end
  
  context 'without accounting_customer_party' do
    before :all do
      @receipt = eval_support_script("serialization/receipt_sample")
      @receipt.customer = nil
      @xml = Nokogiri::XML(@receipt.to_xml)
    end
    
    it 'should show have cac:AccountingCustomerParty tag with a -' do
      accounting_customer_party_tag = @xml.xpath('//cac:AccountingCustomerParty[text()="-"]')
      accounting_customer_party_tag.count.should == 1
    end
  end

end