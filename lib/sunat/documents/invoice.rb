module SUNAT
  class Invoice < BasicInvoice

    ID_FORMAT = /\AF[A-Z\d]{3}-\d{1,8}\Z/
    
    xml_root :Invoice

    validate :required_monetary_totals

    def required_monetary_totals
      valid = additional_monetary_totals.any? {|total| ["1001", "1002", "1003"].include?(total.id) }
      if !valid
        errors.add(:additional_monetary_totals, "has to include the total for taxable, unaffected or exempt operations")
      end
    end

    def build_xml(xml)
      super

      xml['cac'].LegalMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end
    end
  end
end