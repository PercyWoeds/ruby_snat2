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

SUNAT::VoidedDocuments.new.tap do |document|
  document.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
  document.add_line do |line|
    line.document_serial_id = "F125"
    line.document_number_id = "1"
    line.void_reason = "Error en el proceso de generacion"
  end
end

