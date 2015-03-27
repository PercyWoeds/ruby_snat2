
SUNAT.configure do |config|
  config.supplier do |s|
    s.legal_name = "K&G Laboratorios"
    s.ruc        = "20100113612"
    s.address_id = "070101"
    s.street     = "Calle los Olivos 234"
    s.district   = "Callao"
    s.city       = "Lima"
    s.country    = "PE"
  end
end

SUNAT::DailyReceiptSummary.new.tap do |s|
  s.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
  s.notes           = ["nota 1", "nota 2", "nota3"]
  
  s.add_line do |line|
    line.serial_id = "BA98"
    line.start_id = "456"
    line.end_id = "764"
    
    line.add_billing_payment '01', 9823200
    line.add_billing_payment '02', 0
    line.add_billing_payment '03', 23200
    
    line.add_allowance_charge 500, "PEN"
    line.add_allowance_discount 0, "PEN"
    
    line.add_tax_total :isc, 0, "PEN"
    line.add_tax_total :igv, 1768100, "PEN"
  end
end