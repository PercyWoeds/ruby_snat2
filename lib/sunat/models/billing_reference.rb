module SUNAT

  class BillingReference
    include Model

    property :invoice_document_reference, DocumentReference

    def initialize(*attrs)
      super(parse_attributes(*attrs))
    end

    def build_xml(xml)
      xml['cac'].BillingReference do
        xml['cac'].InvoiceDocumentReference do
          invoice_document_reference.build_xml(xml)
        end
      end
    end

    private
      def parse_attributes(attrs = {})
        id                  = attrs.delete(:id)
        document_type_code  = attrs.delete(:document_type_code)

        if id.present? && document_type_code.present?
          self.invoice_document_reference = {id: id, document_type_code: document_type_code}
        end

        attrs
      end

  end
end