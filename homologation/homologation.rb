lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

class DocumentGenerator
  TYPES = {SUNAT::Invoice.name => "01"}
  @@document_serial_id = 1
  def self.generate_documents(group, group_case, document, pdf=false)
    if document.valid?
      File::open("#{document.file_name}.xml", "w") { |file| file.write(document.to_xml) }
      #document.deliver!
      document.to_pdf if pdf
    else
      raise "Invalid document for case #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end
end

class InvoiceGenerator < DocumentGenerator
  
  def self.with_igv(group, group_case, items, serie, pdf=false)
    invoice_data = {id: "#{serie}-#{"%03d" % @@document_serial_id}", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}, 
                    tax_totals: [{amount: items*1800, type: :igv}], legal_monetary_total: 11800 * items, 
                    additional_monetary_totals: [{id: "1001", payable_amount: 10000 * items}]}
    @@document_serial_id += 1
    lines = []
    invoice_data[:lines] = (1..items).map do |item|
      {id: item.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 11800, price: 10000, tax_totals: [{amount: 1800, type: :igv}],
        item: {id: item.to_s, description: "Item #{item}"}}
    end
    
    invoice = SUNAT::Invoice.new(invoice_data)
    generate_documents(group, group_case, invoice, pdf)
    invoice
  end
  
end

class CreditNoteGenerator < DocumentGenerator
  def self.fot_igv_invoice(group, group_case, associated_document, serie, pdf=false)
    line = associated_document.lines.first
    legal_monetary_total = line.line_extension_amount.value + line.tax_totals.inject(0){|sum, tax| sum + tax.tax_amount.value}
    credit_note_data = {id: "#{serie}-#{"%03d" % @@document_serial_id}", customer: associated_document.customer,
                     billing_reference: {id: associated_document.id, document_type_code: TYPES[associated_document.class.name]},
                     discrepancy_response: {reference_id: associated_document.id, response_code: "07", description: "Cliente no satisfecho"},
                     lines: [{id: "1", quantity: line.quantity.quantity, unit: 'NIU', item: line.item,
                          price: line.price, pricing_reference: line.pricing_reference, tax_totals: line.tax_totals, line_extension_amount: line.line_extension_amount}],
                     additional_monetary_totals: [{id: "1001", payable_amount: line.price}], tax_totals: line.tax_totals, 
                     legal_monetary_total: legal_monetary_total}
    @@document_serial_id += 1
    credit_note = SUNAT::CreditNote.new(credit_note_data)
    generate_documents(group, group_case, credit_note, pdf)
    credit_note
  end
end

class DebitNoteGenerator < DocumentGenerator
  def self.fot_igv_invoice(group, group_case, associated_document, serie, pdf=false)
    line = associated_document.lines.first
    legal_monetary_total = line.line_extension_amount.value + line.tax_totals.inject(0){|sum, tax| sum + tax.tax_amount.value}
    debit_note_data = {id: "#{serie}-#{"%03d" % @@document_serial_id}", customer: associated_document.customer,
                       billing_reference: {id: associated_document.id, document_type_code: TYPES[associated_document.class.name]},
                       discrepancy_response: {reference_id: associated_document.id, response_code: "02", description: "Cliente no satisfecho"},
                       lines: [{id: "1", quantity: line.quantity.quantity, unit: 'NIU', item: line.item,
                                price: line.price, pricing_reference: line.pricing_reference, tax_totals: line.tax_totals, line_extension_amount: line.line_extension_amount}],
                        legal_monetary_total: legal_monetary_total}
    @@document_serial_id += 1
    debit_note = SUNAT::DebitNote.new(debit_note_data)
    generate_documents(group, group_case, debit_note, pdf)
    debit_note
  end
end

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
case_6 = CreditNoteGenerator.fot_igv_invoice(1,6, case_2, "FF11")
case_7 = CreditNoteGenerator.fot_igv_invoice(1,7, case_3, "FF11", true)
case_8 = CreditNoteGenerator.fot_igv_invoice(1,8, case_4, "FF11")
case_9 = DebitNoteGenerator.fot_igv_invoice(1,9, case_2, "FF11")
case_10 = DebitNoteGenerator.fot_igv_invoice(1,10, case_3, "FF11", true)
case_11 = DebitNoteGenerator.fot_igv_invoice(1,11, case_4, "FF11")