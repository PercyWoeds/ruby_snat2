
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


$lcPrecioSIgv = 65
$lcPrecioCigv = 77 
$lcCantidad   = 150.00

$lcVVenta    =  9746
$lcIgv       =  1754
$lcTotal     = 11500

$lcGuiaRemision =""

$lcLegalName ="VALLADOLI CERNA JOSE LENIN "
$lcRuc       ="10182264615"
$lcDirCli    ="MZA. E LOTE. 02 URB. SANTA MARIA IV "
$lcDisCli    ="LA LIBERTAD - TRUJILLO - TRUJILLO"
$lcDescrip   ="AJUSTE DE PRECIO  "
$lcPercentIgv  =18000   
$lcAutorizacion="Autorizado mediante Resolucion de Intendencia Nro.034-005-0004185/SUNAT del 26/10/2015 "


# Group 1
debit_note_data = { issue_date: Date.new(2016,8,16), id: "FF01-4", customer: {legal_name:$lcLegalName , ruc:$lcRuc },
                     billing_reference: {id: "FF01-1444", document_type_code: "01"},
                     discrepancy_response: {reference_id: "FF01-1444", response_code: "02", description: $lcDescrip},
                     lines: [{id: "1", item: {id: "05", description: "DIESEL B5 S-50"}, quantity: $lcCantidad, unit: 'GLL', 
                          price: {value: $lcPrecioSIgv}, pricing_reference: $lcPrecioCigv, tax_totals: [{amount: $lcIgv, type: :igv, code: "10"}], line_extension_amount:$lcVVenta }],
                     additional_monetary_totals: [{id: "1001", payable_amount: $lcVVenta}], tax_totals: [{amount: $lcIgv, type: :igv}], legal_monetary_total: $lcTotal}

SUNAT.environment = :production 



files_to_clean = Dir.glob("*.xml") + Dir.glob("./pdf_output/*.pdf") + Dir.glob("*.zip")
files_to_clean.each do |file|
  File.delete(file)
end
$lcAutorizacion=""
$lcCuentas=""

debit_note = SUNAT::DebitNote.new(debit_note_data)
  debit_note.to_pdf

if debit_note.valid?
	begin
	debit_note.deliver!		

	rescue Savon::SOAPFault => e
      puts "Error generating document for case : #{e}"
     	
	end

  File::open("debit_note.xml", "w") { |file| file.write(debit_note.to_xml) }


else
  puts "Invalid document, ignoring output: #{debit_note.errors.messages}"
end

