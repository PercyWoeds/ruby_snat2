module SUNAT
  class DebitNote < BasicInvoice

    ID_FORMAT = /\A[F|B][A-Z\d]{3}-\d{1,8}\Z/

    DOCUMENT_TYPE_CODE = '08' # NOTA DE DEBITO

    xml_root :DebitNote

    property :lines, [DebitNoteLine]
    property :discrepancy_response,      DebitNoteDiscrepancyResponse
    property :billing_reference,         BillingReference

    validates :discrepancy_response, presence: true
    validates :billing_reference, presence: true
    validates :lines, presence: true

    def initialize(*args)
      self.document_type_name ||= "Nota de debito"
      super(*args)
    end

    def document_namespace
      'urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2'
    end

    def add_line(&block)
      line = DebitNoteLine.new.tap(&block)
      self.lines << line
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
      xml['cac'].RequestedMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end
      lines.each do |line|
        line.build_xml xml
      end
    end

  end
end
