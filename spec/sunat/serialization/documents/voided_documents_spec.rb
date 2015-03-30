require 'spec_helper'

describe "serialization of voided documents" do
  include SupportingSpecHelpers
  
  before :all do
    @voided_documents = eval_support_script("serialization/voided_documents_sample")
    @xml = Nokogiri::XML(@voided_documents.to_xml)
  end
  
  it "should include the accounting supplier data from the config" do
    supplier_data = @voided_documents.accounting_supplier_party
    expect(@xml.xpath("//cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID").text).to eq(supplier_data.account_id.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cbc:AdditionalAccountID").text).to eq(supplier_data.additional_account_id.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName").text).to eq(supplier_data.party.party_legal_entity.registration_name.to_s)
  end

  it "should include the lines data" do
    line = @voided_documents.lines.first
    expect(@xml.xpath("//sac:VoidedDocumentsLine/cbc:LineID").text).to eq(line.line_id)
  end
end