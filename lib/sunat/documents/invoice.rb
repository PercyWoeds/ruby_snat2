module SUNAT
  class Invoice < BasicInvoice

    ID_FORMAT = /\AF[A-Z\d]{3}-\d{1,8}\Z/
    
    xml_root :Invoice

    property :allowance_total_amount, AllowanceTotalAmount

    validate :required_monetary_totals

    def document_namespace
      'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'
    end

    def required_monetary_totals
      valid = additional_monetary_totals.any? {|total| ["1001", "1002", "1003"].include?(total.id) }
      if !valid
        errors.add(:additional_monetary_totals, "has to include the total for taxable, unaffected or exempt operations")
      end
    end

    def build_xml(xml)
      super
      xml['cbc'].InvoiceTypeCode      invoice_type_code
      xml['cbc'].DocumentCurrencyCode document_currency_code
      signature.xml_metadata xml
      accounting_supplier_party.build_xml xml
      # sunat says if no customer exists, we must use a dash
      if customer.present?
        customer.build_xml xml
      else
        xml['cac'].AccountingCustomerParty "-"
      end
      
      tax_totals.each do |total|
        total.build_xml xml
      end
      xml['cac'].LegalMonetaryTotal do
        allowance_total_amount.build_xml xml if allowance_total_amount.present?
        legal_monetary_total.build_xml xml, :PayableAmount
      end
      lines.each do |line|
        line.build_xml xml
      end
    end
  end
end