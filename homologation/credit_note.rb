lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

# Group 1

doc = SUNAT::CreditNote.new

doc.requested_monetary_total = SUNAT::PaymentAmount.new(3000)

doc.add_line do |line|
  line.price = SUNAT::PaymentAmount.new(3000)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 250
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

doc.id = "F001-211"

File::open("output.xml", "w") { |file| file.write(doc.to_xml) }

if doc.valid?
  File::open("credit_note.xml", "w") { |file| file.write(doc.to_xml) }
  doc.to_pdf
else
  puts "Invalid document, ignoring output"
end