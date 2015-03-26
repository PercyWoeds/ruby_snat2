Receipt.new.tap do |receipt|
  receipt.id  = "BB11-00000001"
  
  receipt.ruc         = "20100113612"
  receipt.legal_name  = "K&G Laboratorios"
  
  receipt.add_tax_total :igv, 874500, "PEN"
  
  receipt.add_line do |line|
    line.price = SUNAT::PaymentAmount.new(3000)
    line.add_tax_total :igv, 26361, "PEN"
    line.add_tax_total :isc, 8745, "PEN"
  end
end
