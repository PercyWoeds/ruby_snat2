module SUNAT

  class DebitNoteLine < InvoiceLine

    def xml_line_id
      :DebitNoteLine
    end

    def xml_quantity
      :DebitedQuantity
    end
  end

end
