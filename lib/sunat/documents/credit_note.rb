module SUNAT
  class CreditNote < Invoice

    XML_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2'
    XSI_SCHEMA_LOCATION = nil

    ID_FORMAT = /\A[F][A-Z\d]{3}-\d{1,8}\Z/
    DOCUMENT_TYPE_CODE = '07' # NOTA DE CREDITO

    xml_root :CreditNote

    property :discrepancy_response,      DiscrepancyResponse
    property :requested_monetary_total,  PaymentAmount

    property :lines,                     [CreditNoteLine]

    def build_xml(xml)
      super(xml)

      xml['cac'].RequestedMonetaryTotal do
        requested_monetary_total.build_xml xml, :PayableAmount
      end if requested_monetary_total.present?

      discrepancy_response.build_xml(xml) unless discrepancy_response.nil?
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
