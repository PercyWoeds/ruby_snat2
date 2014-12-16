module SUNAT
  class DebitNote < CreditNote

    ID_FORMAT = /[FB][A-Z\d]{3}-\d{1,8}/
    DOCUMENT_TYPE_CODE = '08' # NOTA DE CREDITO

    xml_root :DebitNote

    property :lines, [DebitNoteLine]

    def add_line(&block)
      line = DebitNoteLine.new.tap(&block)
      self.lines << line
    end

    def build_own(xml)

    end

  end
end
