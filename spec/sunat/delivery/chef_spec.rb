require "spec_helper"

include SUNAT::Delivery

describe Chef do
  include SupportingSpecHelpers
  
  before :all do
    @summary = eval_support_script("serialization/daily_receipt_summary_sample")
    @document = @summary.to_xml
    @name = @summary.file_name
  end
  
  describe '#initialize' do
    it "should receive a file_name and xml content" do
      chef = Chef.new @name, @document
      expect(chef.name).to eq @name
      expect(chef.document).to eq @document
    end
  end
  
  describe '#prepare' do
    before :all do
      @is_base_64 = ->(s) do
        !!(s =~ /^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$/)
      end
    end
    
    let :chef do
      Chef.new(@name, @document)
    end
    
    it "returns a base64(byte array)" do
      expect(@is_base_64.call(chef.prepare)).to be true
    end
  end
  
end