#
# Grupo 13 - Resúmenes Diarios
#
# Sample declaration for homologation of Daily Receipt Summary.
#
# Set environment variables, then run:
#
#    ruby daily_receipt_summary.rb
#

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

doc = SUNAT::DailyReceiptSummary.new

doc.reference_date = Date.new(2014, 12, 1)

doc.notes = [
  "Just testing",
  "Notes"
]

40.times do

  doc.add_line do |line|
    line.document_serial_id = 'BB01'
    line.start_id  = '1'
    line.end_id    = '123'
    line.add_billing_payment('01', 3500)
    line.add_tax_total(:isc, 0, 'PEN')
    line.add_allowance_charge(3000, 'PEN')
    line.item = SUNAT::Item.new
    line.item.description = "Cabify Journey In Rolls Royce"
    line.item.id = "ROLLS2014"
    line.quantity = SUNAT::Quantity.new
    line.quantity.quantity = 1
    line.quantity.unit_code = "JOURNEY"
  end

end

doc.correlative_number = "001"

if doc.valid?
  File::open("daily_receipt_summary.xml", "w") { |file| file.write(doc.to_xml) }
  doc.to_pdf
else
  puts "Invalid document, ignoring output"
end