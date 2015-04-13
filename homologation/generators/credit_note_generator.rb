require_relative 'document_generator'

class CreditNoteGenerator < DocumentGenerator
  
  def initialize(group, group_case, serie)
    super(group, group_case)
    @serie = serie
  end

  def for_igv_invoice(associated_document, pdf=false)
    line = associated_document.lines.first
    credit_note = SUNAT::CreditNote.new(credit_note_data_for_line(line, associated_document))
    generate_documents(credit_note, pdf)
    credit_note
  end

  def for_exempt_invoice(associated_document, pdf=false)
    exempt_line = associated_document.lines.last
    
    credit_note = SUNAT::CreditNote.new(credit_note_data_for_line(exempt_line, associated_document))
    generate_documents(credit_note, pdf)
    credit_note
  end

  private 

  def credit_note_data_for_line(line, associated_document)
    legal_monetary_total = line.line_extension_amount.value + line.tax_totals.inject(0){|sum, tax| sum + tax.tax_amount.value}
    credit_note_data = {id: "#{@serie}-#{"%03d" % @@document_serial_id}", customer: associated_document.customer,
                     billing_reference: {id: associated_document.id, document_type_code: TYPES[associated_document.class.name]},
                     discrepancy_response: {reference_id: associated_document.id, response_code: "07", description: "Cliente no satisfecho"},
                     lines: [{id: "1", quantity: line.quantity.quantity, unit: 'NIU', item: line.item,
                          price: line.price, pricing_reference: line.pricing_reference, tax_totals: line.tax_totals, line_extension_amount: line.line_extension_amount}],
                     additional_monetary_totals: [{id: "1001", payable_amount: line.price}], tax_totals: line.tax_totals, 
                     legal_monetary_total: legal_monetary_total}
    @@document_serial_id += 1
    credit_note_data  
  end
end