
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


$lcPrecioSIgv = 803
$lcPrecioCigv = 947
$lcCantidad   = 165.00

$lcVVenta    = 132419
$lcIgv       = 23836
$lcTotal     = 156255

$lcGuiaRemision =""

$lcLegalName ="CONSTRUCTORA CYJ-ECHEVERRIA IZQUIERDO S.A.C. "
$lcRuc       ="20544416147"
$lcDirCli    =" AV. MANUEL OLGUIN NRO. 501 DPTO. 402 URB. MONTERRICO (EDIFICIO MACROS)"
$lcDisCli    ="LIMA - LIMA - SANTIAGO DE SURCO"
$lcDescrip   ="AJUSTE DE PRECIO  "
$lcPercentIgv  =18000   
$lcAutorizacion="Autorizado mediante Resolucion de Intendencia Nro.034-005-0004185/SUNAT del 26/10/2015 "


# Group 1
credit_note_data = { issue_date: Date.new(2016,06,27), id: "FF01-3", customer: {legal_name:$lcLegalName , ruc:$lcRuc },
                     billing_reference: {id: "FF01-1114", document_type_code: "01"},
                     discrepancy_response: {reference_id: "FF01-1114", response_code: "09", description: $lcDescrip},
                     lines: [{id: "1", item: {id: "05", description: "DIESEL B5 S-50"}, quantity: $lcCantidad, unit: 'GLL', 
                          price: {value: $lcPrecioSIgv}, pricing_reference: $lcPrecioCigv, tax_totals: [{amount: $lcIgv, type: :igv, code: "10"}], line_extension_amount:$lcVVenta }],
                     additional_monetary_totals: [{id: "1001", payable_amount: $lcVVenta}], tax_totals: [{amount: $lcIgv, type: :igv}], legal_monetary_total: $lcTotal}

SUNAT.environment = :production


files_to_clean = Dir.glob("*.xml") + Dir.glob("./pdf_output/*.pdf") + Dir.glob("*.zip")
files_to_clean.each do |file|
  File.delete(file)
end

credit_note = SUNAT::CreditNote.new(credit_note_data)
if credit_note.valid?
	begin
	credit_note.deliver!		

	rescue Savon::SOAPFault => e
      puts "Error generating document for case : #{e}"
     	
	end

  File::open("credit_note.xml", "w") { |file| file.write(credit_note.to_xml) }

  credit_note.to_pdf
else
  puts "Invalid document, ignoring output: #{credit_note.errors.messages}"
end


