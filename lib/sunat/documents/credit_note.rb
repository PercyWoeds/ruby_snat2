module SUNAT
  class CreditNote < BasicInvoice

    XSI_SCHEMA_LOCATION = nil

    ID_FORMAT = /\A[F|B][A-Z\d]{3}-\d{1,8}\Z/
    DOCUMENT_TYPE_CODE = '07' # NOTA DE CREDITO

    xml_root :CreditNote

    property :discrepancy_response,      CreditNoteDiscrepancyResponse
    property :billing_reference,         BillingReference

    property :lines,                     [CreditNoteLine]

    validates :discrepancy_response, presence: true
    validates :billing_reference, presence: true
    validates :lines, presence: true

    def document_namespace
      'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2'
    end

    def initialize(*args)
      self.document_type_name ||= "Nota de credito"
      super(*args)
    end

    def build_xml(xml)
      super
      xml['cbc'].DocumentCurrencyCode document_currency_code
      discrepancy_response.build_xml(xml) unless discrepancy_response.nil?
      billing_reference.build_xml(xml)
      signature.xml_metadata xml
      accounting_supplier_party.build_xml xml
      customer.build_xml xml

      tax_totals.each do |total|
        total.build_xml xml
      end
      xml['cac'].LegalMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end
      lines.each do |line|
        line.build_xml xml
      end
    end

    def add_line(&block)
      line = CreditNoteLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

  end
end
