require 'spec_helper'

describe PricingReference do
  it "should generate a pricing reference from an integer" do
    pricing_reference = PricingReference.new(5000)

    expect(pricing_reference.alternative_condition_price.price_amount.value).to eq 5000
  end

  it "should generate a pricing reference from a hash with amount and free keys" do
    pricing_reference = PricingReference.new({amount: 5000, free: true})

    expect(pricing_reference.alternative_condition_price.price_amount.value).to eq 5000
    expect(pricing_reference.alternative_condition_price.price_type).to eq '02'
  end

end