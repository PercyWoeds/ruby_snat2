module SUNAT
  class CreditNote < BasicInvoice

    XML_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2'
    XSI_SCHEMA_LOCATION = nil

    ID_FORMAT = /\A[F][A-Z\d]{3}-\d{1,8}\Z/
    DOCUMENT_TYPE_CODE = '07' # NOTA DE CREDITO

    xml_root :CreditNote

    property :discrepancy_response,      DiscrepancyResponse
    property :billing_reference,         BillingReference
    
    property :lines,                     [CreditNoteLine]

    validates :discrepancy_response, presence: true
    validates :billing_reference, presence: true
    validates :lines, presence: true

    def initialize(*args)
      self.document_type_name ||= "Nota de credito"
      super(*args)
    end

    def build_xml(xml)
      super

      billing_reference.build_xml(xml)

      discrepancy_response.build_xml(xml) unless discrepancy_response.nil?

      xml['cac'].LegalMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end
    end

    def build_own(xml)

    end

    def add_line(&block)
      line = CreditNoteLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

  end
end
