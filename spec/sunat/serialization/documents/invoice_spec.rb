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
    payable_amount_tag = @xml.xpath("//sac:LegalMonetaryTotal/cbc:PayableAmount")
    expect(payable_amount_tag.text).to eq(@invoice.legal_monetary_total.to_s)
  end

  it "should insert the additional monetary totals" do
    total = @invoice.additional_monetary_totals.first
    expect(@xml.xpath("//sac:AdditionalMonetaryTotal/cbc:ID").text).to eq(total.id)
    expect(@xml.xpath("//sac:AdditionalMonetaryTotal/cbc:Name").text).to eq(total.name)
    expect(@xml.xpath("//sac:AdditionalMonetaryTotal/cbc:PayableAmount").text).to eq(total.payable_amount.to_s)
    expect(@xml.xpath("//sac:AdditionalMonetaryTotal/cbc:Percent").text).to eq(total.percent.to_s)
    expect(@xml.xpath("//sac:AdditionalMonetaryTotal/cbc:TotalAmount").text).to eq(total.total_amount.to_s)
  end
end