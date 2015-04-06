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

credit_note_data = { issue_date: Date.new(2012,03,25), id: "F001-211", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"},
                     billing_reference: {id: "F001-4355", document_type_code: "01"},
                     discrepancy_response: {reference_id: "F001-4355", response_code: "07", description: "Unidades defectuosas, no leen CD que contengan archivos MP3"},
                     lines: [{id: "1", item: {id: "GLG199", description: "Grabadora LG Externo Modelo: GE20LU10"}, quantity: 100, unit: 'NIU', 
                          price: {value: 8305}, pricing_reference: 9800, tax_totals: [{amount: 149492, type: :igv, code: "10"}], line_extension_amount: 830508}],
                     additional_monetary_totals: [{id: "1001", payable_amount: 830508}], tax_totals: [{amount: 149492, type: :igv}]}

SUNAT::CreditNote.new(credit_note_data)