require 'spec_helper'
require "sunat/models/allowance_charge"

describe SUNAT::AllowanceCharge do
  let :allowance_charge do
    SUNAT::AllowanceCharge.new
  end
  
  describe "validations" do
    it "should validate that the charge indicator is true or false and no other string" do
      expect(allowance_charge.valid?).to be false
      allowance_charge.charge_indicator = 'no-valid-word'
      expect(allowance_charge.valid?).to be false
      allowance_charge.charge_indicator = 'true'
      expect(allowance_charge.valid?).to be true
      allowance_charge.charge_indicator = 'no-valid-word'
      expect(allowance_charge.valid?).to be false
      allowance_charge.charge_indicator = 'false'
      expect(allowance_charge.valid?).to be  true
    end
  end
end