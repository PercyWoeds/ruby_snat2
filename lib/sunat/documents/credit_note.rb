module SUNAT
  class CreditNote < Invoice

    ID_FORMAT = /[FB][A-Z\d]{3}-\d{1,8}/

    property :discrepancy_reponse,      DiscrepancyResponse
    property :requested_monetary_total, PaymentAmount

    property :lines, [CreditNoteLine]

    def build_xml(xml)
      super(xml)

      xml['cac'].RequestedMonetaryTotal do
        requested_monetary_total.build xml, :PayableAmount
      end if requested_monetary_total.present?

      discrepancy_response.build_xml(xml) unless discrepancy_response.nil?
    end

  end
end
