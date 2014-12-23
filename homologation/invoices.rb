#
# Grupo 1 a 4 - Facturas de Ventas
#
# Set environment variables, then run:
#
#    ruby invoices.rb
#

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


# Group 1

doc = SUNAT::Invoice.new

doc.ruc            = doc.signature.party_id
doc.legal_name     = doc.signature.party_name

doc.company_logo_path = "#{File.dirname(__FILE__)}/logo.png"

40.times do
  doc.add_line do |line|

  	line.price = SUNAT::PaymentAmount.new(3000)

    line.quantity = SUNAT::Quantity.new
    line.quantity.quantity = 250
    line.quantity.unit_code = "JOURNEYS"
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
end

doc.client_data = [
  ["Cliente", "CABIFY"],
  ["Direccion", "Calle amapolas"],
  ["Identificacion", "1231232103"],
  ["Fecha de emision", "DATERINO"],
  ["Fecha de vencimiento", "DATERINO"],
  ["Forma de pago", "Contado"],
  ["Tipo de moneda", "SOLESSSSSS"],
  ["Damn", "Fella"]
]

doc.legal_monetary_total = SUNAT::PaymentAmount.new(5000)

doc.id = "FF11-000001"

if doc.valid?
  doc.to_pdf
  # File::open("output.xml", "w") { |file| file.write(doc.to_xml) }
else
  puts "Invalid document, ignoring output"
  puts doc.errors.full_messages
  puts doc.lines.count
end