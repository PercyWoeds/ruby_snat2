# Sample SUNAT configuration

SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20522012336"
    c.username  = "FACTURA2"
    c.password  = "20522012336"
  end

  config.signature do |s|
    s.party_id    = "20522012336"
    s.party_name  = "HIDROTRANSP S.A.C."
    s.cert_file   = File.join(Dir.pwd, 'keys', 'cert.crt')
    s.pk_file     = File.join(Dir.pwd, 'keys', 'cert.key')
  end

  config.supplier do |s|
    s.legal_name = "HIDROTRANSP S.A.C."
    s.name       = "Cesar Jaime Manrique Milla"
    s.ruc        = "20522012336"
    s.address_id = "150117"
    s.street     = "JR. TOMAS CATARI NRO. 405 URB. EL TREBOL 1RA. ETAPA"
    s.district   = "LOS OLIVOS"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/logo.PNG"
  end
end