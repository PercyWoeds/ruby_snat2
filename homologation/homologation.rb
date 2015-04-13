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

#Group 1
case_1 = InvoiceGenerator.new(1, 1, 3, "FF11").with_igv
case_2 = InvoiceGenerator.new(1, 2, 2, "FF11").with_igv
case_3 = InvoiceGenerator.new(1, 3, 1, "FF11").with_igv(true)
case_4 = InvoiceGenerator.new(1, 4, 5, "FF11").with_igv
case_5 = InvoiceGenerator.new(1, 5, 4, "FF11").with_igv
case_6 = CreditNoteGenerator.new(1, 6, "FF11").for_igv_invoice(case_2)
case_7 = CreditNoteGenerator.new(1, 7, "FF11").for_igv_invoice(case_3, true)
case_8 = CreditNoteGenerator.new(1, 8, "FF11").for_igv_invoice(case_4)
case_9 = DebitNoteGenerator.new(1, 9, "FF11").for_igv_invoice(case_2)
case_10 = DebitNoteGenerator.new(1, 10, "FF11").for_igv_invoice(case_3, true)
case_11 = DebitNoteGenerator.new(1, 11, "FF11").for_igv_invoice(case_4)

#Group 2
case_12 = InvoiceGenerator.new(2, 12, 3, "FF12").exempt
case_13 = InvoiceGenerator.new(2, 13, 4, "FF12").exempt
case_14 = InvoiceGenerator.new(2, 14, 7, "FF12").exempt(true)
case_15 = InvoiceGenerator.new(2, 15, 5, "FF12").exempt
case_16 = InvoiceGenerator.new(2, 16, 6, "FF12").exempt
case_17 = CreditNoteGenerator.new(2, 17, "FF12").for_exempt_invoice(case_12)
case_18 = CreditNoteGenerator.new(2, 18, "FF12").for_exempt_invoice(case_14, true)
case_19 = CreditNoteGenerator.new(2, 19, "FF12").for_exempt_invoice(case_16)
case_20 = CreditNoteGenerator.new(2, 20, "FF12").for_exempt_invoice(case_12)
case_21 = CreditNoteGenerator.new(2, 21, "FF12").for_exempt_invoice(case_14, true)
case_22 = CreditNoteGenerator.new(2, 22, "FF12").for_exempt_invoice(case_16)

#Group 3
case_23 = InvoiceGenerator.new(3, 23, 7, "FF13").free
case_24 = InvoiceGenerator.new(3, 24, 2, "FF13").free(true)
case_25 = InvoiceGenerator.new(3, 25, 5, "FF13").free
case_26 = InvoiceGenerator.new(3, 26, 4, "FF13").free
case_27 = InvoiceGenerator.new(3, 27, 5, "FF13").free

#Group 8
case_52 = ReceiptGenerator.new(8, 52, 3, "BB11").with_igv
case_53 = ReceiptGenerator.new(8, 53, 2, "BB11").with_igv
case_54 = ReceiptGenerator.new(8, 54, 1, "BB11").with_igv(true)
case_55 = ReceiptGenerator.new(8, 55, 5, "BB11").with_igv
case_56 = ReceiptGenerator.new(8, 56, 4, "BB11").with_igv
case_57 = CreditNoteGenerator.new(8, 57, "BB11").for_igv_invoice(case_53)
case_58 = CreditNoteGenerator.new(8, 58, "BB11").for_igv_invoice(case_54, true)
case_59 = CreditNoteGenerator.new(8, 59, "BB11").for_igv_invoice(case_55)
case_60 = DebitNoteGenerator.new(8, 60, "BB11").for_igv_invoice(case_53)
case_61 = DebitNoteGenerator.new(8, 61, "BB11").for_igv_invoice(case_54,true)
case_62 = DebitNoteGenerator.new(8, 62, "BB11").for_igv_invoice(case_55)

#Group 9
case_63 = ReceiptGenerator.new(9, 63, 2, "FF12").exempt
case_64 = ReceiptGenerator.new(9, 64, 4, "FF12").exempt
case_65 = ReceiptGenerator.new(9, 65, 7, "FF12").exempt(true)
case_66 = ReceiptGenerator.new(9, 66, 5, "FF12").exempt
case_67 = ReceiptGenerator.new(9, 67, 1, "FF12").exempt
case_68 = CreditNoteGenerator.new(9, 68, "FF12").for_exempt_invoice(case_63)
case_69 = CreditNoteGenerator.new(9, 69, "FF12").for_exempt_invoice(case_66, true)
case_70 = CreditNoteGenerator.new(9, 70, "FF12").for_exempt_invoice(case_67)
case_71 = CreditNoteGenerator.new(9, 71, "FF12").for_exempt_invoice(case_63)
case_72 = CreditNoteGenerator.new(9, 72, "FF12").for_exempt_invoice(case_66, true)
case_73 = CreditNoteGenerator.new(9, 73, "FF12").for_exempt_invoice(case_67)
