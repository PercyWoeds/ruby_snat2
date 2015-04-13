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
case_6 = CreditNoteGenerator.new(1, 6, "FF11").for_igv_document(case_2)
case_7 = CreditNoteGenerator.new(1, 7, "FF11").for_igv_document(case_3, true)
case_8 = CreditNoteGenerator.new(1, 8, "FF11").for_igv_document(case_4)
case_9 = DebitNoteGenerator.new(1, 9, "FF11").for_igv_document(case_2)
case_10 = DebitNoteGenerator.new(1, 10, "FF11").for_igv_document(case_3, true)
case_11 = DebitNoteGenerator.new(1, 11, "FF11").for_igv_document(case_4)

#Group 2
case_12 = InvoiceGenerator.new(2, 12, 3, "FF12").exempt
case_13 = InvoiceGenerator.new(2, 13, 4, "FF12").exempt
case_14 = InvoiceGenerator.new(2, 14, 7, "FF12").exempt(true)
case_15 = InvoiceGenerator.new(2, 15, 5, "FF12").exempt
case_16 = InvoiceGenerator.new(2, 16, 6, "FF12").exempt
case_17 = CreditNoteGenerator.new(2, 17, "FF12").for_exempt_document(case_12)
case_18 = CreditNoteGenerator.new(2, 18, "FF12").for_exempt_document(case_14, true)
case_19 = CreditNoteGenerator.new(2, 19, "FF12").for_exempt_document(case_16)
case_20 = DebitNoteGenerator.new(2, 20, "FF12").for_exempt_document(case_12)
case_21 = DebitNoteGenerator.new(2, 21, "FF12").for_exempt_document(case_14, true)
case_22 = DebitNoteGenerator.new(2, 22, "FF12").for_exempt_document(case_16)

#Group 3
case_23 = InvoiceGenerator.new(3, 23, 7, "FF13").free
case_24 = InvoiceGenerator.new(3, 24, 2, "FF13").free(true)
case_25 = InvoiceGenerator.new(3, 25, 5, "FF13").free
case_26 = InvoiceGenerator.new(3, 26, 4, "FF13").free
case_27 = InvoiceGenerator.new(3, 27, 3, "FF13").free

#For some reason group 4 case numbers are not consecutive to case 3 ones.

#Group 4
case_32 = InvoiceGenerator.new(4, 32, 2, "FF14").with_discount
case_33 = InvoiceGenerator.new(4, 33, 1, "FF14").with_discount(true)
case_34 = InvoiceGenerator.new(4, 34, 4, "FF14").with_discount
case_35 = InvoiceGenerator.new(4, 35, 3, "FF14").with_discount
case_36 = InvoiceGenerator.new(4, 36, 5, "FF14").with_discount
case_37 = CreditNoteGenerator.new(4, 37, "FF14").for_discount_invoice(case_33, true)
case_38 = CreditNoteGenerator.new(4, 38, "FF14").for_discount_invoice(case_34)
case_39 = CreditNoteGenerator.new(4, 39, "FF14").for_discount_invoice(case_36)
case_40 = DebitNoteGenerator.new(4, 40, "FF14").for_discount_invoice(case_33, true)
case_41 = DebitNoteGenerator.new(4, 41, "FF14").for_discount_invoice(case_34)
case_42 = DebitNoteGenerator.new(4, 42, "FF14").for_discount_invoice(case_36)

#Group 5
case_43 = InvoiceGenerator.new(5, 43, 5, "FF30").with_isc

#Group 8
case_52 = ReceiptGenerator.new(8, 52, 3, "BB11").with_igv
case_53 = ReceiptGenerator.new(8, 53, 2, "BB11").with_igv
case_54 = ReceiptGenerator.new(8, 54, 1, "BB11").with_igv(true)
case_55 = ReceiptGenerator.new(8, 55, 5, "BB11").with_igv
case_56 = ReceiptGenerator.new(8, 56, 4, "BB11").with_igv
case_57 = CreditNoteGenerator.new(8, 57, "BB11").for_igv_document(case_53)
case_58 = CreditNoteGenerator.new(8, 58, "BB11").for_igv_document(case_54, true)
case_59 = CreditNoteGenerator.new(8, 59, "BB11").for_igv_document(case_55)
case_60 = DebitNoteGenerator.new(8, 60, "BB11").for_igv_document(case_53)
case_61 = DebitNoteGenerator.new(8, 61, "BB11").for_igv_document(case_54,true)
case_62 = DebitNoteGenerator.new(8, 62, "BB11").for_igv_document(case_55)

#Group 9
case_63 = ReceiptGenerator.new(9, 63, 2, "BB12").exempt
case_64 = ReceiptGenerator.new(9, 64, 4, "BB12").exempt
case_65 = ReceiptGenerator.new(9, 65, 7, "BB12").exempt(true)
case_66 = ReceiptGenerator.new(9, 66, 5, "BB12").exempt
case_67 = ReceiptGenerator.new(9, 67, 1, "BB12").exempt
case_68 = CreditNoteGenerator.new(9, 68, "BB12").for_exempt_document(case_63)
case_69 = CreditNoteGenerator.new(9, 69, "BB12").for_exempt_document(case_66, true)
case_70 = CreditNoteGenerator.new(9, 70, "BB12").for_exempt_document(case_67)
case_71 = DebitNoteGenerator.new(9, 71, "BB12").for_exempt_document(case_63)
case_72 = DebitNoteGenerator.new(9, 72, "BB12").for_exempt_document(case_66, true)
case_73 = DebitNoteGenerator.new(9, 73, "BB12").for_exempt_document(case_67)

#Group 10
case_74 = ReceiptGenerator.new(10, 74, 7, "BB13").free
case_75 = ReceiptGenerator.new(10, 75, 2, "BB13").free
case_76 = ReceiptGenerator.new(10, 76, 5, "BB13").free(true)
case_77 = ReceiptGenerator.new(10, 77, 4, "BB13").free
case_78 = ReceiptGenerator.new(10, 78, 9, "BB13").free

#Group 11
case_85 = ReceiptGenerator.new(11, 85, 10, "BB14").with_discount
case_86 = ReceiptGenerator.new(11, 86, 7, "BB14").with_discount(true)
case_87 = ReceiptGenerator.new(11, 87, 6, "BB14").with_discount
case_88 = ReceiptGenerator.new(11, 88, 9, "BB14").with_discount
case_89 = ReceiptGenerator.new(11, 89, 4, "BB14").with_discount
case_90 = CreditNoteGenerator.new(11, 90, "BB14").for_discount_invoice(case_85)
case_91 = CreditNoteGenerator.new(11, 91, "BB14").for_discount_invoice(case_86, true)
case_92 = CreditNoteGenerator.new(11, 92, "BB14").for_discount_invoice(case_88)
case_93 = DebitNoteGenerator.new(11, 92, "BB14").for_discount_invoice(case_85)
case_94 = DebitNoteGenerator.new(11, 94, "BB14").for_discount_invoice(case_86, true)
case_95 = DebitNoteGenerator.new(11, 95, "BB14").for_discount_invoice(case_88)