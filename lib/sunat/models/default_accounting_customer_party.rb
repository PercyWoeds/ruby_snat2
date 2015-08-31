module SUNAT
  class DefaultAccountingCustomerParty < AccountingParty
    validates :account_id, existence: true, presence: true
    validates :additional_account_id, presence: true

    def initialize(*attrs)
      super(*attrs)

      self.additional_account_id = "-"
      self.account_id = "-"
      self.party.party_legal_entity.registration_name = "-"
      self.party.name = "-"
    end

    def build_xml(xml)
      xml['cac'].AccountingCustomerParty do
        build_xml_payload(xml)
      end
    end
  end
end
