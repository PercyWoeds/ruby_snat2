require 'spec_helper'

describe do
  include ValidationSpecHelpers
  
  let :accounting_party do
    SUNAT::AccountingSupplierParty.new
  end
  
  describe "validations" do
    let(:invalid_code) { "124" }
    let(:valid_code) { ActiveModel::Validations::DocumentTypeCodeValidator::VALID_CODES.sample }
    
    it "should validate that the account_id needs to have 11 characters" do
      expect_invalid  accounting_party, :account_id, "1" * 5
      expect_valid    accounting_party, :account_id, "1" * 11
    end
    
    it "should validate that the additional_account_id is a valid document type code" do
      expect_invalid accounting_party,  :additional_account_id, invalid_code
      expect_valid accounting_party,    :additional_account_id, valid_code
    end
  end

  describe ".new" do
    it "should build a new accounting party with name and ruc" do
      ap = SUNAT::AccountingSupplierParty.new(:name => "Test Company", :ruc => "123456789")
      ap.account_id.should eql("123456789")
      ap.additional_account_id.should eql(SUNAT::AccountingSupplierParty::RUC_DOCUMENT_CODE)
      ap.party.party_legal_entities.first.registration_name.should eql("Test Company")
    end

    it "should build new accounting party with name and dni" do
      ap = SUNAT::AccountingSupplierParty.new(:name => "Test Company", :dni => "123456789")
      ap.account_id.should eql("123456789")
      ap.additional_account_id.should eql(SUNAT::AccountingSupplierParty::DNI_DOCUMENT_CODE)
      ap.party.name.should eql("Test Company")
    end

    it "should still continue to operatre with normal hash" do
      ap = SUNAT::AccountingSupplierParty.new(:name => "Test Company", :ruc => "123456789")
      ap = SUNAT::AccountingSupplierParty.new(ap.as_json)
      ap.account_id.should eql("123456789")
      ap.additional_account_id.should eql(SUNAT::AccountingSupplierParty::RUC_DOCUMENT_CODE)
      ap.party.party_legal_entities.first.registration_name.should eql("Test Company")
    end   
  end
  
end
