require_relative 'document_generator'

class InvoiceGenerator < DocumentGenerator

  def self.with_igv(group, group_case, items, serie, pdf=false)
    invoice = SUNAT::Invoice.new(data(serie, items))
    generate_documents(group, group_case, invoice, pdf)
    invoice
  end

  def self.exempt(group, group_case, items, serie, pdf=false)
    invoice_data = data(serie, items - 1)
    invoice_data[:lines] << {id: items.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 10000, price: 10000,
                             item: {id: items.to_s, description: "Item #{items}"}, tax_totals: [{amount: 0, type: :igv, code: "20"}], line_extension_amount: 10000}
    invoice_data[:additional_monetary_totals] << {id: "1003", payable_amount: 10000}
    invoice = SUNAT::Invoice.new(invoice_data)
    invoice.legal_monetary_total.value = invoice.legal_monetary_total.value + 10000
    generate_documents(group, group_case, invoice, pdf)
    invoice
  end
  
  private
    def self.data(serie, items)
      invoice_data = {id: "#{serie}-#{"%03d" % @@document_serial_id}", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}, 
                    tax_totals: [{amount: items*1800, type: :igv}], legal_monetary_total: 11800 * items, 
                    additional_monetary_totals: [{id: "1001", payable_amount: 10000 * items}]}
      @@document_serial_id += 1
      invoice_data[:lines] = []
      if items > 0
        invoice_data[:lines] = (1..items).map do |item|
          {id: item.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 11800, price: 10000, tax_totals: [{amount: 1800, type: :igv}],
            item: {id: item.to_s, description: "Item #{item}"}}
        end
      end
      invoice_data
    end
end