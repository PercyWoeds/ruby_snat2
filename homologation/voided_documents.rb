lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


# Group 1

voided_documents_data = {reference_date: Date.new(2011,4,1), issue_date: Date.new(2011,4,2), id: "RA-20110401-001", correlative_number: "001",
                         lines: [{line_id: "1", document_type_code: "01", document_serial_id: "F001", document_number_id: "1", void_reason: "Error en sistema"},
                                 {line_id: "2", document_type_code: "01", document_serial_id: "F001", document_number_id: "15", void_reason: "Cancelacion"}]}

voided_document = SUNAT::VoidedDocuments.new(voided_documents_data)
if voided_document.valid?
  File::open("voided_document.xml", "w") { |file| file.write(voided_document.to_xml) }
  voided_document.to_pdf
else
  puts "Invalid document, ignoring output: #{voided_document.errors.messages}"
end

doc = SUNAT::VoidedDocuments.new

doc.reference_date  = Date.new(2012,06,23)
doc.id = "RA-#{doc.issue_date.strftime("%Y%m%d")}-001"
doc.add_line do |line|
  line.document_serial_id = "F125"
  line.document_number_id = "1"
  line.void_reason = "Error en el proceso de generacion"
end