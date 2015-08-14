# encoding: utf-8

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

debit_note_data = {id: "F001-0005", issue_date: Date.new(2012,7,21), customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}, 
                   discrepancy_response: {description: "Ampliación garantía de memoria DDR-3 B1333 Kingston", reference_id: "F001-4355", response_code: "02"}, requested_monetary_total: 125000, 
                   lines: [{id: "1", quantity: 1, unit: "ZZ", item: {description: "Ampliación de garantía de 6 a 12 meses de Memoria DDR-3 B1333 Kingston"}, 
                      price: 500, pricing_reference: 500, tax_totals: [{type: :igv, code: "20", amount: 0}], line_extension_amount:  125000}],
                      legal_monetary_total: 125000, billing_reference: {id: "F001-4355", document_type_code: "01"}}

debit_note = SUNAT::DebitNote.new(debit_note_data)
