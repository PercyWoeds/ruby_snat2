require 'spec_helper'

describe do
  include ValidationSpecHelpers

  let :accounting_party do
    SUNAT::AccountingSupplierParty.new(additional_account_id: AccountingSupplierParty::DOCUMENT_TYPES_DATA[:ruc])
  end

  describe "validations" do
    let(:invalid_code) { "124" }
    let(:valid_code) { ActiveModel::Validations::DocumentTypeCodeValidator::VALID_CODES.sample }

    it "should validate that the account_id needs to have 11 characters for ruc ids" do
      expect_invalid  accounting_party, :account_id, "1" * 5
      expect_valid    accounting_party, :account_id, "1" * 11
    end

    it "should validate that the additional_account_id is a valid document type code" do
      expect_invalid accounting_party,  :additional_account_id, invalid_code
      expect_valid accounting_party,    :additional_account_id, valid_code
    end
  end

  describe ".new" do
    it "should build a new accounting party with legal name, name and ruc" do
      ap = SUNAT::AccountingSupplierParty.new(:legal_name => "Legal Test", :name => "Test Company", :ruc => "123456789")
      expect(ap.account_id).to eql("123456789")
      expect(ap.additional_account_id).to eql(SUNAT::AccountingSupplierParty::DOCUMENT_TYPES_DATA[:ruc])
      expect(ap.party.name).to eql("Test Company")
      expect(ap.party.party_legal_entity.registration_name).to eql("Legal Test")
    end

    it "should build new accounting party with name and dni" do
      ap = SUNAT::AccountingSupplierParty.new(:name => "Test Company", :dni => "123456789")
      expect(ap.account_id).to eql("123456789")
      expect(ap.additional_account_id).to eql(SUNAT::AccountingSupplierParty::DOCUMENT_TYPES_DATA[:dni])
      expect(ap.party.name).to eql("Test Company")
    end

    it "should still continue to operate with normal hash" do
      ap = SUNAT::AccountingSupplierParty.new(:legal_name => "Legal Test", :name => "Test Company", :ruc => "123456789")
      ap = SUNAT::AccountingSupplierParty.new(ap.as_json)
      expect(ap.account_id).to eql("123456789")
      expect(ap.additional_account_id).to eql(SUNAT::AccountingSupplierParty::DOCUMENT_TYPES_DATA[:ruc])
      expect(ap.party.name).to eql("Test Company")
      expect(ap.party.party_legal_entity.registration_name).to eql("Legal Test")
    end
  end

end
