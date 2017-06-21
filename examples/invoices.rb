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

invoice_data = {id: "F001-4355", issue_date: "2013-03-14", customer: {legal_name: "XServicabinas S.A.", ruc: "20587896411",addresses: [{ address_id:"15017", street:"Av. Ayacucho 9090 " , zone:"Surco", city:"Lima", province:"Lima", district:"Lima", country:"PE"}],
                lines: [{id: "1", item: {id: "GLG199", description: "Grabadora LG Externo Modelo: GE20LU10"}, quantity: 2000.0, unit: 'NIU', 
                          price: {value: 8305}, pricing_reference: 9800, tax_totals: [{amount: 2690847, type: :igv, code: "10"}], line_extension_amount: 14949153},
                        {id: "2", item: {id: "MVS546", description: "Monitor LCD ViewSonic VG2028WM 20\""}, quantity: 300.0, unit: 'NIU', 
                          price: {value: 52542}, pricing_reference: 62000, tax_totals: [{amount: 2411695, type: :igv, code: "10"}], line_extension_amount: 13398305},
                        {id: "3", item: {id: "MPC35", description: "Memoria DDR-3 B1333 Kingston"}, quantity: 250.0, unit: 'NIU', 
                          price: {value: 5200}, pricing_reference: 5200, tax_totals: [{amount: 0, type: :igv, code: "20"}], line_extension_amount: 1300000},
                        {id: "4", item: {id: "TMS22", description: "Teclado Microsoft SideWinder X6"}, quantity: 500.0, unit: 'NIU', 
                          price: {value: 16610}, pricing_reference: 19600, tax_totals: [{amount: 1494915, type: :igv, code: "10"}], line_extension_amount: 8305085},
                        {id: "5", item: {id: "WCG01", description: "Web cam Genius iSlim 310"}, quantity: 1.0, unit: 'NIU', 
                          price: {value: 0}, pricing_reference: {amount: 3000, free: true}, tax_totals: [{amount: 0, type: :igv, code: "31"}], line_extension_amount: 0}],
                additional_monetary_totals: [{id: "1001", payable_amount: 34819915}, {id: "1003", payable_amount: 1235000}, 
                                             {id: "1004", payable_amount: 3000}, {id: "2005", payable_amount: 5923051}],
                legal_monetary_total: 42325500, tax_totals: [{amount: 6267585, type: :igv}]
                }

invoice = SUNAT::Invoice.new(invoice_data)

if invoice.valid?
  File::open("invoice.xml", "w") { |file| file.write(invoice.to_xml) }
  invoice.to_pdf
else
  puts "Invalid document, ignoring output: #{invoice.errors.messages}"
end
