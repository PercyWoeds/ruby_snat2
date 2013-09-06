module SUNAT
  class AccountingCustomerParty < AccountingSupplierParty
   
    def build_xml(xml)
      xml['cac'].AccountingCustomerParty do
        build_xml_payload(xml)
      end
    end

  end
end
