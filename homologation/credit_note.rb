lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

# Group 1
credit_note_data = { issue_date: Date.new(2012,03,25), id: "F001-211", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"},
                     billing_reference: {id: "F001-4355", document_type_code: "01"},
                     discrepancy_response: {reference_id: "F001-4355", response_code: "07", description: "Unidades defectuosas, no leen CD que contengan archivos MP3"},
                     lines: [{id: "1", item: {id: "GLG199", description: "Grabadora LG Externo Modelo: GE20LU10"}, quantity: 100, unit: 'NIU', 
                          price: {value: 8305}, pricing_reference: 9800, tax_totals: [{amount: 149492, type: :igv, code: "10"}], line_extension_amount: 830508}],
                     additional_monetary_totals: [{id: "1001", payable_amount: 830508}], tax_totals: [{amount: 149492, type: :igv}], legal_monetary_total: 979999}

credit_note = SUNAT::CreditNote.new(credit_note_data)
if credit_note.valid?
  File::open("credit_note.xml", "w") { |file| file.write(credit_note.to_xml) }
  credit_note.to_pdf
else
  puts "Invalid document, ignoring output: #{credit_note.errors.messages}"
end