lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


# Group 1

doc = SUNAT::VoidedDocuments.new

doc.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
doc.id = "RA-#{doc.issue_date.strftime("%Y%m%d")}-001"
doc.add_line do |line|
  line.document_serial_id = "F125"
  line.document_number_id = "1"
  line.void_reason = "Error en el proceso de generacion"
end

File::open("output.xml", "w") { |file| file.write(doc.to_xml) }