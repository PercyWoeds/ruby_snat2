require 'spec_helper'

describe SUNAT::Invoice do
  include ValidationSpecHelpers
  include SupportingSpecHelpers
  
  let :invoice do
    SUNAT::Invoice.new
  end
  
  describe "#initialize" do    
    it "should begins with the correct DOCUMENT_TYPE_CODE" do
      expect(invoice.invoice_type_code).to eq(SUNAT::Invoice::DOCUMENT_TYPE_CODE)
    end
  end
  
  describe "validations" do    
    it 'should valid that document_currency_code is a valid code' do
      expect_valid    invoice, :document_currency_code, "PEN"
      expect_valid    invoice, :document_currency_code, "123"
      expect_invalid  invoice, :document_currency_code, "12P"
      expect_invalid  invoice, :document_currency_code, "PE04"
    end
    
    it "should valid that invoice_type_code is a valid code" do
      expect_invalid  invoice, :invoice_type_code, "AB"
      expect_invalid  invoice, :invoice_type_code, "013"
      expect_valid    invoice, :invoice_type_code, "12"
    end
  end
  
  describe "#add_line" do
    it "should yield a line of InvoiceLine" do
      invoice.add_line do |line|
        expect(line).to be_kind_of(InvoiceLine)
      end
    end
    it "should add a line to the summary lines" do
      initial_lines = invoice.lines.size
      invoice.add_line { }
      expect(invoice.lines.size).to eq (initial_lines + 1)
    end
    it "should add a line with a consecutive line_id beginning in 1" do
      invoice.add_line { }
      invoice.add_line { }
      invoice.add_line { }
      
      expect(invoice.lines[0].id).to eq "1"
      expect(invoice.lines[1].id).to eq "2"
      expect(invoice.lines[2].id).to eq "3"
    end
  end
  
  context "with an existing and big invoice" do
    
    before :all do
      @invoice = eval_support_script("serialization/invoice_sample")
    end
    
    describe "#file_name" do    
      it "include all the parts of the invoice file name" do
        ruc = @invoice.accounting_supplier_party.account_id
        kind = @invoice.class::DOCUMENT_TYPE_CODE
        id = @invoice.id

        expect(@invoice.file_name).to eq("#{ruc}-#{kind}-#{id}")
      end
    end
  end
end
