module SUNAT
  class AllowanceTotalAmount < PaymentAmount
    def build_xml(xml)
      super(xml, :AllowanceTotalAmount)
    end
  end
end