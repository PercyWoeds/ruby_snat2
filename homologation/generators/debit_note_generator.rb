require_relative 'document_generator'

class DebitNoteGenerator < DocumentGenerator

  def initialize(group, group_case, serie)
    super(group, group_case)
    @serie = serie
  end

  def for_igv_document(associated_document, pdf=false)
    line = associated_document.lines.first
    debit_note = SUNAT::DebitNote.new(debit_note_data_for_line(line, associated_document))
    generate_documents(debit_note, pdf)
    debit_note
  end

  def for_exempt_document(associated_document, pdf=false)
    exempt_line = associated_document.lines.last
    debit_note = SUNAT::DebitNote.new(debit_note_data_for_line(exempt_line, associated_document))
    generate_documents(debit_note, pdf)
    debit_note
  end

  def for_discount_invoice(associated_document, pdf=false)
    line = associated_document.lines.first
    debit_note = SUNAT::DebitNote.new(debit_note_data_for_line(line, associated_document))
    taxable_total = debit_note.get_monetary_total_by_id("1001")
    discount = (taxable_total.payable_amount.value * 0.05).round
    taxable_total.payable_amount = taxable_total.payable_amount.value - discount
    debit_note.add_additional_monetary_total({id: "2005", payable_amount: discount})
    debit_note.modify_monetary_total(taxable_total)
    new_tax_totals = {amount: (taxable_total.payable_amount.to_f * 18).round, type: :igv}
    debit_note.legal_monetary_total = new_tax_totals[:amount] + taxable_total.payable_amount.value
    debit_note.tax_totals = [new_tax_totals]
    generate_documents(debit_note, pdf)
    debit_note
  end

  private
  def debit_note_data_for_line(line, associated_document)
    legal_monetary_total = line.line_extension_amount.value + line.tax_totals.inject(0){|sum, tax| sum + tax.tax_amount.value}
    debit_note_data = {id: "#{@serie}-#{"%03d" % @@document_serial_id}", customer: associated_document.customer,
                       billing_reference: {id: associated_document.id, document_type_code: TYPES[associated_document.class.name]},
                       discrepancy_response: {reference_id: associated_document.id, response_code: "07", description: "Cliente no satisfecho"},
                       lines: [{id: "1", quantity: line.quantity.quantity, unit: 'NIU', item: line.item,
                                price: line.price, pricing_reference: line.pricing_reference, tax_totals: line.tax_totals, line_extension_amount: line.line_extension_amount}],
                       additional_monetary_totals: [{id: "1001", payable_amount: line.price}], tax_totals: line.tax_totals, 
                       legal_monetary_total: legal_monetary_total}
    @@document_serial_id += 1
    debit_note_data  
  end
end
