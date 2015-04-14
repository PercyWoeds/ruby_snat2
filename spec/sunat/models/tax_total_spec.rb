require 'spec_helper'

describe SUNAT::TaxTotal do
  it "should allow to set the tax amount currency to something different than PEN" do
    tax_total = SUNAT::TaxTotal.new({amount: {value: 1800, currency: 'EUR'}, type: :igv})

    expect(tax_total.tax_amount.currency).to eq 'EUR'
  end
end