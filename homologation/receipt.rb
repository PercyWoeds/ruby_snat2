#
# Boleta de Ventas
#
# Set environment variables, then run:
#
#    ruby receipt.rb
#

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


# Group 1
receipt_data = {id: "BC01-3652", customer: {dni: "00078647", legal_name: "Soledad Asuncion Carrasco Perez"},
               lines: [{id: "1", unit: "NIU", quantity: 1, item: {id: "REF564", description: "Refrigeradora marca \"AXM\" no frost de 200 ltrs"}, pricing_reference: 99800,
                          tax_totals: [{amount: 15224, type: :igv, code: "10"}]}]}

receipt = SUNAT::Receipt.new(receipt_data)

if receipt.valid?
  File::open("receipt.xml", "w") { |file| file.write(receipt.to_xml) }
  receipt.to_pdf
else
  puts "Invalid document, ignoring output: #{receipt.errors.messages}"
end

doc = SUNAT::Receipt.new

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

doc.id = "B001-564"