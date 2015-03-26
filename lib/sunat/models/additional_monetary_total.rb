module SUNAT
  class AdditionalMonetaryTotal
    include Model
    
    property :id,               String
    property :name,             String
    property :payable_amount,   PaymentAmount
    property :reference_amount, PaymentAmount
    property :total_amount,     PaymentAmount
    property :percent,          Float
    
    def build_xml(xml)
      xml['sac'].AdditionalMonetaryTotal do
        xml['cbc'].ID id
        xml['cbc'].Name name if name.present?
        payable_amount.build_xml(xml,   :PayableAmount) if payable_amount.present?
        reference_amount.build_xml(xml, :ReferenceAmount) if reference_amount.present?
        total_amount.build_xml(xml,     :TotalAmount) if total_amount.present?
        
        xml['cbc'].Percent(percent) if percent.present?
      end
    end
  end
end
