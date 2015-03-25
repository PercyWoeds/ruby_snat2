require 'spec_helper'

include SUNAT

describe DailyReceiptSummary do
  include SupportingSpecHelpers
  
  let :summary do
    DailyReceiptSummary.new
  end
  
  describe "#initialize" do
    it "should initialize with no notes." do
      summary.notes.should_not be_nil
      summary.notes.should be_empty
    end
    
    it "should initialize with no lines." do
      summary.lines.should_not be_nil
      summary.lines.should be_empty
    end
    
    it 'should initialize with an id' do
      summary.id.should_not be_empty
    end
    
    it "should have a default id starting with RC- and containing the current date in format YYYYMMDD" do
      formatted_date = Date.today.strftime("%Y%m%d")
      
      summary.id.should_not be_nil
      summary.id.should start_with("RC-")
      summary.id.should end_with(formatted_date)
    end
  end
  
  describe "#add_line" do
    it "should yield a line of SummaryDocumentsLine" do
      summary.add_line do |line|
        line.should be_kind_of(SummaryDocumentsLine)
      end
    end
    it "should add a line to the summary lines" do
      initial_lines = summary.lines.size
      summary.add_line { }
      summary.lines.size.should == initial_lines + 1
    end
    it "should add a line with a consecutive line_id beginning in 1" do
      summary.add_line { }
      summary.add_line { }
      summary.add_line { }
      
      summary.lines[0].line_id.should == "1"
      summary.lines[1].line_id.should == "2"
      summary.lines[2].line_id.should == "3"
    end
  end
  
  describe "#file_name" do
    before :all do
      @daily_receipt = eval_support_script("serialization/daily_receipt_summary_sample")
    end
    
    it "has a summary type of 2 characters" do
      @daily_receipt.class::SUMMARY_TYPE.size.should eq(2)
    end
    
    it "include all the parts of the daily receipt summary file name" do
      ruc = @daily_receipt.ruc
      kind = @daily_receipt::class::SUMMARY_TYPE
      date = @daily_receipt.issue_date.strftime("%Y%m%d")
      correlative_number = @daily_receipt.correlative_number
      
      @daily_receipt.file_name.should eq("#{ruc}-RC-#{date}-#{correlative_number}")
    end
  end  
end
