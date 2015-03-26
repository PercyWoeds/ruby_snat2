require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of an invoice' do
  include SupportingSpecHelpers
  
  before :all do
    @invoice = eval_support_script("serialization/invoice_sample")
    @xml = Nokogiri::XML(@invoice.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    expect(date.count).to be >= 0
    expect(date.text).to eq(Date.today.strftime("%Y-%m-%d"))
  end
  
  it "should insert the payment amount into the xml body" do
    payable_amount_tag = @xml.xpath("//sac:AdditionalMonetaryTotal/cbc:PayableAmount")
    expect(payable_amount_tag.count).to be >= 0
    expect(payable_amount_tag.text).to eq(@invoice.legal_monetary_total.to_s)
  end
end