module SUNAT

  class DebitNoteLine < InvoiceLine

    def build_xml(xml)
      xml['cac'].DebitNoteLine do
        build_xml_generic_payload(xml)
        quantity.build_xml(xml, :DebitedQuantity) if quantity.present?
      end
    end

  end

end
