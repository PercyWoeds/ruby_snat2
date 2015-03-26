require "spec_helper"

include SUNAT
include SUNAT::Delivery

describe Sender do
  include SupportingSpecHelpers
  
  before :all do
    @summary        = eval_support_script("serialization/daily_receipt_summary_sample")
    @document       = @summary.to_xml
    @name           = @summary.file_name
    @operation      = @summary.operation
    @chef           = Chef.new(@name, @document)
    @encoded_zip    = @chef.prepare
  end
  
  let :sender do
    sender = Sender.new(@name, @encoded_zip, @operation)
    sender
  end
  
  describe "#initialize" do  
    it "receives a name and encoded_zip" do
      expect(sender.name).to eq @name
      expect(sender.encoded_zip).to eq @encoded_zip
      expect(sender.operation).to eq @operation
    end
  end
  
  describe "#connect" do
    it "should get a list of operations" do
      if SUNAT::CREDENTIALS.ruc.present?
        sender.connect
        sender.client.operations.tap do |it|        
          expect(it).to_not be_nil
          expect(it).to respond_to(:size)
          expect(it.size).to be > 0
        end
      end
    end
  end
  
  describe "#send" do    
    it "should not raise an error" do
      if SUNAT::CREDENTIALS.ruc.present?
        expect do
          sender.call
        end.to_not raise_error
      end
    end
  end

end