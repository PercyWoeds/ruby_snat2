require 'spec_helper'

describe DebitNote do
  include SupportingSpecHelpers
  
  before :all do
    @debit_note = eval_support_script("serialization/debit_note_sample")
    @xml = Nokogiri::XML(@debit_note.to_xml)
  end

  it "should include the discrepancy response data" do
    expect(@xml.xpath("//cac:DiscrepancyResponse/cbc:ReferenceID").text).to eq @debit_note.discrepancy_response.reference_id
    expect(@xml.xpath("//cac:DiscrepancyResponse/cbc:ResponseCode").text).to eq @debit_note.discrepancy_response.response_code
    expect(@xml.xpath("//cac:DiscrepancyResponse/cbc:Description").text).to eq @debit_note.discrepancy_response.description
  end

  it "should include the billing reference data" do
    expect(@xml.xpath("//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID").text).to eq @debit_note.billing_reference.invoice_document_reference.id
    expect(@xml.xpath("//cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode").text).to eq @debit_note.billing_reference.invoice_document_reference.document_type_code
  end

  it "should include the debit note lines data" do
    expect(@xml.xpath("//cac:DebitNoteLine/cbc:ID").text).to eq @debit_note.lines.first.id
  end
end