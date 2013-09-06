module SUNAT
  class DebitNote < CreditNote

    property :lines, [DebitNoteLine]

  end
end
