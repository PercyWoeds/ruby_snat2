# Sample SUNAT configuration

SUNAT.configure do |config|
  config.credentials do |c|
    c.ruc       = "20548704261"
    c.username  = YOUR_USERNAME
    c.password  = YOUR_PASSWORD
  end

  config.signature do |s|
    s.party_id    = "20548704261"
    s.party_name  = "MAXI MOBILITY PERU S.A.C."
    s.cert_file   = File.join(Dir.pwd, 'keys', 'sunat.crt')
    s.pk_file     = File.join(Dir.pwd, 'keys', 'sunat-decrypted.key')
  end

  config.supplier do |s|
    s.legal_name = "MAXI MOBILITY PERU S.A.C."
    s.name       = "Cabify"
    s.ruc        = "20548704261"
    s.address_id = "150140"
    s.street     = "AV. MONTERREY 373 904 URB. CHACARILLA DEL ESTANQUE"
    s.district   = "SANTIAGO DE SURCO"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/logo.png"
  end
end