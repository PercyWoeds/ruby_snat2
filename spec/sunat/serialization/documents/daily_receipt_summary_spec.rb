require 'spec_helper'

include SUNAT

describe 'serialization of a daily receipt summary' do
  include SupportingSpecHelpers
  
  before :all do
    @summary = eval_support_script("serialization/daily_receipt_summary_sample")
    @xml = Nokogiri::XML(@summary.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    expect(date.count).to eq 1
    expect(date.text).to eq(Date.today.strftime("%Y-%m-%d"))
  end
  
  it "should have a root named SummaryDocuments" do
    expect(@xml.root.name).to eq("SummaryDocuments")
  end
  
  it "should have a cbc:ID tag named with the id of the summary" do
    expect(@xml.xpath("/*/cbc:ID").first.text).to eq(@summary.id)
  end
  
  it "should have many cbc:Note tags containing the contents of the notes" do
    expect(@xml.xpath("//cbc:Note").map do |node|
      node.text
    end).to eq(@summary.notes.to_a)
  end
  
  it "should have a total amount" do
    expect(@xml.xpath("//sac:TotalAmount").count).to eq 1
  end
  
  describe "node AccountingSupplier" do
    it "should have CustomerAssignedAccountID equivalent to the account_id" do
      expect(@xml.xpath("//cbc:CustomerAssignedAccountID").text).to eq(@summary.accounting_supplier_party.account_id)
    end
    it "should have AdditionalAccountID equivalent to the additional_account_id" do
      expect(@xml.xpath("//cbc:AdditionalAccountID").text).to eq(@summary.accounting_supplier_party.additional_account_id)
    end
    
    describe "node Party" do
      it "should insert a entity name into the xml" do
        entity_name_location = "//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"
        xml_entity_name = @xml.xpath(entity_name_location).text
        oo_entity_name = @summary.accounting_supplier_party.party.party_legal_entity.registration_name
        
        expect(xml_entity_name).to eq(oo_entity_name)
      end
    end
  end
  
end