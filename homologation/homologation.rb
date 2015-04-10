lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'
require './generators/invoice_generator'
require './generators/credit_note_generator'
require './generators/debit_note_generator'
require './generators/receipt_generator'

files_to_clean = Dir.glob("*.xml") + Dir.glob("./pdf_output/*.pdf")
files_to_clean.each do |file|
  File.delete(file)
end

#Groupo 1
case_1 = InvoiceGenerator.with_igv(1,1,3, "FF11")
case_2 = InvoiceGenerator.with_igv(1,2,2, "FF11")
case_3 = InvoiceGenerator.with_igv(1,3,1, "FF11", true)
case_4 = InvoiceGenerator.with_igv(1,4,5, "FF11")
case_5 = InvoiceGenerator.with_igv(1,5,4, "FF11")
case_6 = CreditNoteGenerator.for_igv_invoice(1,6, case_2, "FF11")
case_7 = CreditNoteGenerator.for_igv_invoice(1,7, case_3, "FF11", true)
case_8 = CreditNoteGenerator.for_igv_invoice(1,8, case_4, "FF11")
case_9 = DebitNoteGenerator.for_igv_invoice(1,9, case_2, "FF11")
case_10 = DebitNoteGenerator.for_igv_invoice(1,10, case_3, "FF11", true)
case_11 = DebitNoteGenerator.for_igv_invoice(1,11, case_4, "FF11")

#Grupo 2
#case_12 = InvoiceGenerator.exempt(2,12,1, "FF12")

#Groupo 8
case_52 = ReceiptGenerator.with_igv(12,52,3, "BB11")
case_53 = ReceiptGenerator.with_igv(12,53,2, "BB11")
case_54 = ReceiptGenerator.with_igv(12,54,1, "BB11", true)
case_55 = ReceiptGenerator.with_igv(12,55,5, "BB11")
case_56 = ReceiptGenerator.with_igv(12,56,4, "BB11")
case_57 = CreditNoteGenerator.for_igv_invoice(12,57, case_53, "BB11")
case_58 = CreditNoteGenerator.for_igv_invoice(12,58, case_54, "BB11", true)
case_59 = CreditNoteGenerator.for_igv_invoice(12,59, case_55, "BB11")
case_60 = DebitNoteGenerator.for_igv_invoice(12,60, case_53, "BB11")
case_61 = DebitNoteGenerator.for_igv_invoice(12,61, case_54, "BB11", true)
case_62 = DebitNoteGenerator.for_igv_invoice(12,62, case_55, "BB11")