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
doc.ruc            = doc.signature.party_id
doc.legal_name     = doc.signature.party_name

doc.notes = [
  "Just testing",
  "Notes"
]

doc.add_line do |line|
  line.serial_id = 'BB01'
  line.start_id  = '1'
  line.end_id    = '123'
  line.add_billing_payment('01', 3500)
  line.add_tax_total(:isc, 0, 'PEN')
  line.add_allowance_charge(3000, 'PEN')
end

doc.correlative_number = "001"

if doc.valid?
  doc.to_pdf
  # File::open("output.xml", "w") { |file| file.write(doc.to_xml) }
else
  puts "Invalid document, ignoring output"
  puts doc.errors.full_messages
  puts doc.lines.count
end