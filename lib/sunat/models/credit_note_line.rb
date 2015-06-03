module SUNAT

  class CreditNoteLine < InvoiceLine
    
    def xml_line_id
      :CreditNoteLine
    end

    def xml_quantity
      :CreditedQuantity
    end
  end

end
