module SUNAT
  class DebitNote < BasicInvoice

    ID_FORMAT = /\A[F][A-Z\d]{3}-\d{1,8}\Z/
    DOCUMENT_TYPE_CODE = '08' # NOTA DE CREDITO

    xml_root :DebitNote

    property :lines, [DebitNoteLine]
    property :discrepancy_response,      DiscrepancyResponse
    property :billing_reference,         BillingReference
    property :requested_monetary_total,  PaymentAmount

    validates :discrepancy_response, presence: true
    validates :billing_reference, presence: true
    validates :requested_monetary_total, presence: true

    def initialize(*args)
      self.document_type_name ||= "Nota de debito"
      super(*args)
    end

    def add_line(&block)
      line = DebitNoteLine.new.tap(&block)
      self.lines << line
    end

    def build_xml(xml)
      super
      
      discrepancy_response.build_xml xml
      billing_reference.build_xml xml

      xml['cac'].RequestedMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end
    end
    def build_own(xml)

    end

  end
end
