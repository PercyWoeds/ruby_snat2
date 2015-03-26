require 'spec_helper'
require "sunat/models/summary_documents_line"

describe SUNAT::SummaryDocumentsLine do
  let :line do
    SUNAT::SummaryDocumentsLine.new
  end
  
  describe "#initialize" do
    it "should initialize with 0 billing_payments." do
      expect(line.billing_payments).to_not be_nil
      expect(line.billing_payments).to be_empty
    end
    
    it "should have a default document_type_code" do
      expect(line.document_type_code).to eql SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end
  end
  
  describe '#add_billing_payment' do
    it 'should add a billing_payment/paid_amount to the line' do
      line.add_billing_payment('01', 1200, "PEN")
      
      expect(line.billing_payments.size).to eq(1)
      expect(line.billing_payments.first).to be_kind_of(SUNAT::BillingPayment)
      expect(line.billing_payments.first.paid_amount).to be_kind_of(SUNAT::PaymentAmount)
      expect(line.billing_payments.first).to be_valid
      expect(line.billing_payments.first.instruction_id).to eql('01')
    end

    it 'should accept ammount without currency' do
      line.add_billing_payment('01', 1200)
      expect(line.billing_payments.first).to be_valid
      expect(line.billing_payments.first.paid_amount.currency).to eql('PEN')
    end
  end
  
  describe '#add_allowance_charge & #add_allowance_discount' do
    it 'should add a charge to the line' do
      line.add_allowance_charge(10000, 'USD')
      expect(line.allowance_charges.size).to eql 1
    end
    
    it 'should set the amount of the charge to the params of the method' do
      v, c = [1000, 'USD']
      line.add_allowance_charge(v, c)
      
      charge = line.allowance_charges.first
      expect(charge.amount.currency).to eql c
      expect(charge.amount.value).to eql v
    end
  end
  
  describe '#add_allowance_charge' do
    it 'should set the charge_indicator to "true"' do
      line.add_allowance_charge(10000, 'USD')
      charge = line.allowance_charges.first
      expect(charge.charge_indicator).to eql "true"
    end
  end
  
  describe '#add_allowance_discount' do
    it 'should set the charge_indicator to "false"' do
      line.add_allowance_discount(10000, 'USD')
      charge = line.allowance_charges.first
      expect(charge.charge_indicator).to eql "false"
    end
  end
  
  describe '#total_amount' do
    def test_with_7_amounts(amounts)
      a, b, c, d, e, f, g = amounts
      
      line.add_billing_payment '01', a, "PEN"
      line.add_billing_payment '02', b, "PEN"
      line.add_billing_payment '03', c, "PEN"
    
      line.add_allowance_charge d, "PEN"
      line.add_allowance_discount e, "PEN"
    
      line.add_tax_total :isc, f, "PEN"
      line.add_tax_total :igv, g, "PEN"
      
      expect(line.total_amount.value).to eq(amounts.inject(&:+))
    end
        
    it 'should sum all the positive amounts' do
      test_with_7_amounts [9823200, 0, 23200, 500, 0, 0, 1768100]
    end
    
    it 'can substract when some negative value are found' do
      # the 5th value is a discount, so this should work
      test_with_7_amounts [9823200, 0, 23200, 500, 500, 0, 1768100]
    end
  end
end
