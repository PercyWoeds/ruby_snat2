lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

# Group 1
debit_note_data = {id: "F001-0005", issue_date: Date.new(2012,7,21), customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}, 
                   discrepancy_response: {description: "Ampliación garantía de memoria DDR-3 B1333 Kingston", reference_id: "F001-4355", response_code: "02"}, 
                   lines: [{id: "1", quantity: 1.0, unit: "ZZ", item: {description: "Ampliación de garantía de 6 a 12 meses de Memoria DDR-3 B1333 Kingston"}, 
                      price: 500, pricing_reference: 500, tax_totals: [{type: :igv, code: "20", amount: 0}], line_extension_amount:  125000}],
                      legal_monetary_total: 125000, billing_reference: {id: "F001-4355", document_type_code: "01"}}

debit_note = SUNAT::DebitNote.new(debit_note_data)

if debit_note.valid?
  File::open("debit_note.xml", "w") { |file| file.write(debit_note.to_xml) }
  debit_note.to_pdf
else
  puts "Invalid document, ignoring output: #{debit_note.errors.messages}"
end

doc = SUNAT::DebitNote.new

doc.legal_monetary_total = SUNAT::PaymentAmount.new(3000)

doc.add_line do |line|
  line.price = SUNAT::PaymentAmount.new(3000)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 250.0
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(4000)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(3000)

  line.item = SUNAT::Item.new
  line.item.description = "Cabify Journey In Rolls Royce"
  line.item.id = "ROLLS2014"

  line.add_tax_total(:igv, 3000)
  line.add_tax_total(:isc, 5000)


end

doc.legal_monetary_total = SUNAT::PaymentAmount.new(5000)

doc.id = "F002-10"