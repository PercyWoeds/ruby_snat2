#
# Grupo 1 a 4 - Facturas de Ventas
#
# Set environment variables, then run:
#
#    ruby invoices.rb
#

lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require '../config'


# Group 1

doc = SUNAT::Invoice.new

doc.ruc            = doc.signature.party_id
doc.legal_name     = doc.signature.party_name

doc.company_logo_path = "#{File.dirname(__FILE__)}/../logo.png"

# line example

doc.add_line do |line|

	line.price = SUNAT::PaymentAmount.new(8305)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 2000
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(14949153)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(9800)
  line.pricing_reference.alternative_condition_price.price_type = '01' #default 01


  line.item = SUNAT::Item.new
  line.item.description = "Grabadora LG Externo Modelo: GE20LU10"
  line.item.id = "GLG199"

  line.add_tax_total(:igv, 2690847)
  # line.add_tax_total(:isc, 5000)

end


doc.add_line do |line|

  line.price = SUNAT::PaymentAmount.new(52542)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 300
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(13398305)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(62000)


  line.item = SUNAT::Item.new
  line.item.description = "Monitor LCD ViewSonic VG2028WM 20"
  line.item.id = "MVS546"

  line.add_tax_total(:igv, 2690847)

end


doc.add_line do |line|

  line.price = SUNAT::PaymentAmount.new(5200)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 250
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(1300000)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(5200)


  line.item = SUNAT::Item.new
  line.item.description = "Memoria DDR-3 B1333 Kingston"
  line.item.id = "MPC35"

  line.add_tax_total(:igv, 0)

end


doc.add_line do |line|

  line.price = SUNAT::PaymentAmount.new(16610)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 500
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(8305085)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(19600)


  line.item = SUNAT::Item.new
  line.item.description = "Teclado Microsoft SideWinder X6"
  line.item.id = "TMS22"

  line.add_tax_total(:igv, 1494915)

end


doc.add_line do |line|

  line.price = SUNAT::PaymentAmount.new(16610)

  line.quantity = SUNAT::Quantity.new
  line.quantity.quantity = 5
  line.quantity.unit_code = "NIU"
  line.line_extension_amount = SUNAT::PaymentAmount.new(0)

  line.pricing_reference = SUNAT::PricingReference.new
  line.pricing_reference.alternative_condition_price = SUNAT::AlternativeConditionPrice.new
  line.pricing_reference.alternative_condition_price.price_amount = SUNAT::PaymentAmount.new(0)


  line.item = SUNAT::Item.new
  line.item.description = "Web cam Genius iSlim 310VVU"
  line.item.id = "WCG01"

  line.add_tax_total(:igv, 0, SUNAT::ANNEX::CATALOG_07[9])

end


doc.add_additional_property({
  :id => "192389284",
  :value => "This is a custom additional property"
})

doc.add_additional_monetary_total({
  :id => "623432432",
  :payable_amount => SUNAT::PaymentAmount.new(2000),
  :name => "CUSTOM-AMT"
})


# You can add here some cells about your client data
# and payment data and they will be shown in the PDF
# in a table before the items table
# This data is totally customizable and it won't
# modify the xml

doc.client_data = [
  ["Cliente", "CABIFY"],
  ["Direccion", "Calle Amapolas Verdes 5, Winterfell"],
  ["Identificacion", "1231232103"],
  ["Fecha de emision", "01-01-2015"],
  ["Fecha de vencimiento", "01-01-2015"],
  ["Forma de pago", "Contado"],
  ["Tipo de moneda", "Nuevos Soles"]
]

doc.legal_monetary_total = SUNAT::PaymentAmount.new(doc.total_price)

doc.id = "F001-4355"

if doc.valid?
  doc.pdf_path = "invoice.pdf"
  doc.to_pdf
  File::open("own_invoice.xml", "w") { |file| file.write(doc.to_xml) }
else
  puts "Invalid document, ignoring output"
  puts doc.errors.full_messages
  puts doc.lines.count
end