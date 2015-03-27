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

  it "should include the accounting supplier data from the config" do
    supplier_data = @invoice.accounting_supplier_party
    expect(@xml.xpath("//cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID").text).to eq(supplier_data.account_id.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cbc:AdditionalAccountID").text).to eq(supplier_data.additional_account_id.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name").text).to eq(supplier_data.party.name.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName").text).to eq(supplier_data.party.party_legal_entity.registration_name.to_s)
    address = supplier_data.party.postal_addresses.first
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID").text).to eq(address.id.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName").text).to eq(address.street_name.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName").text).to eq(address.city_subdivision_name.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName").text).to eq(address.city_name.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity").text).to eq(address.country_subentity.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District").text).to eq(address.district.to_s)
    expect(@xml.xpath("//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode").text).to eq(address.country.identification_code.to_s)
  end
end