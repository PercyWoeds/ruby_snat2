module SUNAT

  class TaxSubTotal
    include Model
    
    property :tax_amount,   PaymentAmount
    property :tax_category, TaxCategory
    
    def build_xml(xml)
      xml['cac'].TaxSubtotal do
        tax_amount.build_xml xml, :TaxAmount
        tax_category.build_xml(xml) if tax_category
      end
    end
  end
end