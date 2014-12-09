module SUNAT

  class BillingPayment
    include Model

    property :paid_amount,    PaymentAmount
    property :instruction_id, String

    validates :instruction_id, :inclusion => SUNAT::ANNEX::CATALOG_11
    
    def build_xml(xml)
      xml['sac'].BillingPayment do
        paid_amount.build_xml xml, :PaidAmount
        xml['cbc'].InstructionID instruction_id
      end
    end

  end

end
