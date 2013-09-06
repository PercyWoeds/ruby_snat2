module SUNAT

  class CreditNoteLine < InvoiceLine

    def build_xml(xml)
      xml['cac'].CreditNoteLine do
        build_xml_generic_payload(xml)
        quantity.build_xml(xml, :CreditedQuantity) if quantity.present?
      end
    end

  end

end
