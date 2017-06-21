 lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'
require './generators/invoice_generator'
require './generators/credit_note_generator'
require './generators/debit_note_generator'
require './generators/receipt_generator'
require './generators/daily_receipt_summary_generator'
require './generators/voided_documents_generator'

SUNAT.environment = :test

files_to_clean = Dir.glob("*.xml") + Dir.glob("./pdf_output/*.pdf") + Dir.glob("*.zip")
files_to_clean.each do |file|
  File.delete(file)
end 

#case_3 = InvoiceGenerator.new(1, 3, 1, "FF01").with_igv(true)

#case_49 = InvoiceGenerator.new(7, 49, 1, "FF50").with_different_currency
case_96 = ReceiptGenerator.new(12, 96, 1, "BB50").with_different_currency
#groups = ARGV.present? ? ARGV[0].split(",").map(&:to_i) : (1..14).to_a


#if groups.include?(12)
#  case_96 = ReceiptGenerator.new(12, 96, 3, "BB50").with_different_currency
#  case_97 = CreditNoteGenerator.new(12, 97, "BB50").for_different_currency_document(case_96)
#  case_98 = DebitNoteGenerator.new(12, 98, "BB50").for_different_currency_document(case_96)
#end

#case_6 = CreditNoteGenerator.new(1, 6, "FF01").for_igv_document(case_3,true)
# case_6 = CreditNoteGenerator.new(1, 6, "FF01").for_igv_document(true)

#case_6 = CreditNoteGenerator.new(1, 6, "FF01").for_igv_document(true)
#VoidedDocumentsGenerator.new.generate

#Resumen Diario boletas de venta 13
#if groups.include?(13)
 # DailyReceiptSummaryGenerator.new.generate
#end

#Comunicacion de baja 14
#if groups.include?(14)
  VoidedDocumentsGenerator.new.generate
#end




