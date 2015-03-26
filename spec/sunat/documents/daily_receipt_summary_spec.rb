require 'spec_helper'

include SUNAT

describe DailyReceiptSummary do
  include SupportingSpecHelpers
  
  let :summary do
    DailyReceiptSummary.new
  end
  
  describe "#initialize" do
    it "should initialize with no notes." do
      expect(summary.notes).to_not be_nil
      expect(summary.notes).to be_empty
    end
    
    it "should initialize with no lines." do
      expect(summary.lines).to_not be_nil
      expect(summary.lines).to be_empty
    end
    
    it 'should initialize with an id' do
      expect(summary.id).to_not be_empty
    end
    
    it "should have a default id starting with RC- and containing the current date in format YYYYMMDD" do
      formatted_date = Date.today.strftime("%Y%m%d")
      
      expect(summary.id).to_not be_nil
      expect(summary.id).to start_with("RC-")
      expect(summary.id).to end_with(formatted_date)
    end
  end

  describe "#add_line" do
    it "should yield a line of SummaryDocumentsLine" do
      summary.add_line do |line|
        expect(line).to be_kind_of(SummaryDocumentsLine)
      end
    end
    it "should add a line to the summary lines" do
      initial_lines = summary.lines.size
      summary.add_line { }
      expect(summary.lines.size).to eq(initial_lines + 1)
    end
    it "should add a line with a consecutive line_id beginning in 1" do
      summary.add_line { }
      summary.add_line { }
      summary.add_line { }
      
      expect(summary.lines[0].line_id).to eq "1"
      expect(summary.lines[1].line_id).to eq "2"
      expect(summary.lines[2].line_id).to eq "3"
    end
  end
  
  describe "#file_name" do
    before :all do
      @daily_receipt = eval_support_script("serialization/daily_receipt_summary_sample")
    end
    
    it "has a summary type of 2 characters" do
      expect(@daily_receipt.class::SUMMARY_TYPE.size).to eq(2)
    end
    
    it "include all the parts of the daily receipt summary file name" do
      ruc = @daily_receipt.accounting_supplier_party.account_id
      kind = @daily_receipt::class::SUMMARY_TYPE
      date = @daily_receipt.issue_date.strftime("%Y%m%d")
      correlative_number = @daily_receipt.correlative_number
      
      expect(@daily_receipt.file_name).to eq("#{ruc}-RC-#{date}-#{correlative_number}")
    end
  end  
end
