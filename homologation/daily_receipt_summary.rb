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

doc.reference_date = Date.new(2013, 8, 27)
doc.ruc            = doc.signature.party_id
doc.legal_name     = doc.signature.party_name

doc.add_line do |line|
  line.serial_id = 'BB01'
  line.start_id  = '1'
  line.end_id    = '123'
  line.add_billing_payment('01', 3500)
end

doc.correlative_number = "001"

# Document prepared! Try sending.
puts "Sending document..."
#res = doc.deliver!
puts doc.to_xml
puts "DONE!"
