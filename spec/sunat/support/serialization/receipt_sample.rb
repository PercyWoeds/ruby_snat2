SUNAT.configure do |config|
  config.supplier do |s|
    s.name       = "MAXI MOBILITY PERU S.A.C."
    s.ruc        = "201548704261"
    s.address_id = "070101"
    s.street     = "Calle los Olivos 234"
    s.district   = "Callao"
    s.city       = "Lima"
    s.country    = "PE"
  end
end

Receipt.new.tap do |receipt|
  receipt.id  = "BB11-00000001"
  
  receipt.legal_name  = "K&G Laboratorios"
  
  receipt.add_tax_total :igv, 874500, "PEN"
  
  receipt.add_line do |line|
    line.price = SUNAT::PaymentAmount.new(3000)
    line.add_tax_total :igv, 26361, "PEN"
    line.add_tax_total :isc, 8745, "PEN"
  end

  receipt.legal_monetary_total = SUNAT::PaymentAmount.new(42322500)

end