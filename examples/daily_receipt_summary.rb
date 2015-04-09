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

daily_receipt_summary_data = {reference_date: Date.new(2012, 6, 23), issue_date: Date.new(2012, 6, 24), id: "RC-20120624-001", correlative_number: "001",
                              lines: [{line_id: "1", document_type_code: "03", document_serial_id: "BA98", start_id: "456", end_id: "764", 
                                  billing_payments: [{paid_amount: 9823200, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 23200, instruction_id: "03"}],
                                  allowance_charges: [{amount: 500, charge_indicator: 'true'}], tax_totals: [{amount: 1768176, type: :igv}, {amount: 0, type: :isc}, {amount: 120000, type: :other}]},
                                  {line_id: "2", document_type_code: "03", document_serial_id: "BC23", start_id: "789", end_id: "932", 
                                  billing_payments: [{paid_amount: 7822300, instruction_id: "01"}, {paid_amount: 2442300, instruction_id: "02"}, {paid_amount: 0, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 1408014, type: :igv}, {amount: 0, type: :isc}]},
                                  {line_id: "3", document_type_code: "07", document_serial_id: "BC11", start_id: "23", end_id: "89", 
                                  billing_payments: [{paid_amount: 2322300, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 0, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 418014, type: :igv}, {amount: 0, type: :isc}]},
                                  {line_id: "4", document_type_code: "03", document_serial_id: "BD21", start_id: "12", end_id: "230", 
                                  billing_payments: [{paid_amount: 7124200, instruction_id: "01"}, {paid_amount: 7882900, instruction_id: "02"}, {paid_amount: 510300, instruction_id: "03"}],
                                  allowance_charges: [{amount: 34500, charge_indicator: 'true'}], tax_totals: [{amount: 1282356, type: :igv}, {amount: 234200, type: :isc}]},
                                  {line_id: "5", document_type_code: "08", document_serial_id: "B234", start_id: "902", end_id: "1459", 
                                  billing_payments: [{paid_amount: 6443400, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 1256795, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 1159812, type: :igv}, {amount: 0, type: :isc}]}]
                              }
daily_receipt_summary = SUNAT::DailyReceiptSummary.new(daily_receipt_summary_data)

if daily_receipt_summary.valid?
  File::open("daily_receipt_summary.xml", "w") { |file| file.write(daily_receipt_summary.to_xml) }
  daily_receipt_summary.to_pdf
else
  puts "Invalid document, ignoring output: #{daily_receipt_summary.errors.messages}"
end

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
  end

end

doc.correlative_number = "001"