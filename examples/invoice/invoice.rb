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


# You can use ruby code to create your invoice

doc = SUNAT::Invoice.new

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

# I add a property
doc.add_additional_property({
  :id => SUNAT::ANNEX::CATALOG_15[0],
  :value => "This is an additional property that I'll replace"
})

# I modify the additional I want to replace or I simply add a new one
# Also, using this helper to textify PaymentAmounts we can create montos
doc.modify_additional_property_by_id({
  :id => SUNAT::ANNEX::CATALOG_15[0],
  :value => SUNAT::PaymentAmount.new(42322500).textify.upcase
})

# I want to add an additional monetary total, so I will use
# this method to do it

doc.add_additional_monetary_total({
  :id => SUNAT::ANNEX::CATALOG_14[0],
  :payable_amount => SUNAT::PaymentAmount.new(0)
})

# Ops... I've mistaked, so I want to overwrite a monetary total with
# this id so I'll use the modify method, that will remove all amt with
# the Id provided and then add the new one

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[0],
  :payable_amount => SUNAT::PaymentAmount.new(34819915)
})

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[1],
  :payable_amount => SUNAT::PaymentAmount.new(0)
})

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[2],
  :payable_amount => SUNAT::PaymentAmount.new(1235000)
})

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[3],
  :payable_amount => SUNAT::PaymentAmount.new(3000)
})

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[4],
  :payable_amount => SUNAT::PaymentAmount.new(0)
})

doc.modify_monetary_total_by_id({
  :id => SUNAT::ANNEX::CATALOG_14[9],
  :payable_amount => SUNAT::PaymentAmount.new(5923051)
})

doc.legal_monetary_total = SUNAT::PaymentAmount.new(42322500)

doc.id = "F001-4355"

#Or you can define it with a hash for the properties.

invoice_data = {id: "F001-4355", issue_date: "2013-03-14", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}, 
                lines: [{item: {id: "GLG199", description: "Grabadora LG Externo Modelo: GE20LU10"}, quantity: 2000, unit: 'NIU', 
                          price: {value: 8305}, pricing_reference: 9800, tax_totals: [{amount: 2690847, type: :igv, code: "10"}], line_extension_amount: 14949153},
                        {item: {id: "MVS546", description: "Monitor LCD ViewSonic VG2028WM 20\""}, quantity: 300, unit: 'NIU', 
                          price: {value: 52542}, pricing_reference: 62000, tax_totals: [{amount: 2411695, type: :igv, code: "10"}], line_extension_amount: 13398305},
                        {item: {id: "MPC35", description: "Memoria DDR-3 B1333 Kingston"}, quantity: 250, unit: 'NIU', 
                          price: {value: 5200}, pricing_reference: 5200, tax_totals: [{amount: 0, type: :igv, code: "20"}], line_extension_amount: 1300000},
                        {item: {id: "TMS22", description: "Teclado Microsoft SideWinder X6"}, quantity: 500, unit: 'NIU', 
                          price: {value: 16610}, pricing_reference: 19600, tax_totals: [{amount: 1494915, type: :igv, code: "10"}], line_extension_amount: 8305085},
                        {item: {id: "WCG01", description: "Web cam Genius iSlim 310"}, quantity: 1, unit: 'NIU', 
                          price: {value: 0}, pricing_reference: {amount: 3000, free: true}, tax_totals: [{amount: 0, type: :igv, code: "31"}], line_extension_amount: 0}],
                additional_monetary_totals: [{id: "1001", payable_amount: 34819915}, {id: "1003", payable_amount: 1235000}, 
                                             {id: "1004", payable_amount: 3000}, {id: "2005", payable_amount: 5923051}],
                legal_monetary_total: 42325500, tax_totals: [{amount: 6267585, type: :igv}], additional_properties: [{id: "1000", value: SUNAT::PaymentAmount.new(42322500).textify.upcase}]
                }
doc = SUNAT::Invoice.new(invoice_data)

if doc.valid?
  doc.to_pdf("invoice.pdf")
  File::open("own_invoice.xml", "w") { |file| file.write(doc.to_xml) }
else
  puts "Invalid document, ignoring output"
  puts doc.errors.full_messages
end
