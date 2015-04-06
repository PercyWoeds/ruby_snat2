require 'spec_helper'

describe 'serialization of a credit note' do
  include SupportingSpecHelpers

  before :all do
    @credit_note= eval_support_script("serialization/credit_note_sample")
    @xml = Nokogiri::XML(@credit_note.to_xml)
  end

  it "should include the billing reference data" do
    expect(@xml.xpath("//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID").text).to eq(@credit_note.billing_reference.invoice_document_reference.id)
    expect(@xml.xpath("//cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode").text).to eq(@credit_note.billing_reference.invoice_document_reference.document_type_code)
  end
end