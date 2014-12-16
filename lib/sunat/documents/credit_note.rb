module SUNAT
  class CreditNote < Invoice

    ID_FORMAT = /[FB][A-Z\d]{3}-\d{1,8}/

    property :discrepancy_response,      DiscrepancyResponse
    property :requested_monetary_total,  PaymentAmount

    property :lines,                     [CreditNoteLine]

    def build_xml(xml)
      super(xml)

      xml['cac'].RequestedMonetaryTotal do
        requested_monetary_total.build_xml xml, :PayableAmount
      end if requested_monetary_total.present?

      discrepancy_response.build_xml(xml) unless discrepancy_response.nil?
    end

    def add_line(&block)
      line = CreditNoteLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

  end
end
