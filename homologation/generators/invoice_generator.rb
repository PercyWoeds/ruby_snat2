require_relative 'document_generator'

class InvoiceGenerator < DocumentGenerator
  attr_reader :items

  def initialize(group, group_case, items, serie)
    super(group, group_case)
    @items = items
    @serie = serie
  end

  def with_igv(pdf=false)
    invoice = document_class.new(data(@items))
    generate_documents(invoice, pdf)
    invoice
  end

  def exempt(pdf=false)
    invoice_data = data
    invoice_data[:lines] = (1..@items).map do |item|
      {id: item.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 10000, price: 10000,
       item: {id: item.to_s, description: "Item #{item}"}, tax_totals: [{amount: 0, type: :igv, code: "20"}], line_extension_amount: 10000}
    end
    invoice_data[:additional_monetary_totals] << {id: "1003", payable_amount: @items*10000}
    invoice = document_class.new(invoice_data)
    invoice.legal_monetary_total.value = invoice.legal_monetary_total.value + @items*10000
    generate_documents(invoice, pdf)
    invoice
  end
  
  def free(pdf=false)
    invoice_data = data
    invoice_data[:lines] = (1..@items).map do |item|
      {id: @items.to_s, quantity: 1, line_extension_amount: 0, pricing_reference: {amount: 10000, free: true}, price: 0,
       item: {id: @items.to_s, description: "Item #{@items}"}, tax_totals: [{amount: 0, type: :igv, code: "31"}], line_extension_amount: 0}
    end
    invoice_data[:additional_monetary_totals] << {id: "1004", payable_amount: @items*10000}
    invoice_data[:additional_properties] = [{id: "1002", value: "TRANSFERENCIA GRATUITA"}]
    invoice = document_class.new(invoice_data)
    generate_documents(invoice, pdf)
    invoice
  end

  def with_discount(pdf=false)
    invoice = document_class.new(data(@items))
    
    taxable_total = invoice.get_monetary_total_by_id("1001")
    discount = (taxable_total.payable_amount.value * 0.05).round
    taxable_total.payable_amount = taxable_total.payable_amount.value - discount
    new_tax_totals = {amount: (taxable_total.payable_amount.to_f * 18).round, type: :igv}

    invoice.allowance_total_amount = discount
    invoice.modify_monetary_total(taxable_total)
    invoice.add_additional_monetary_total({id: "2005", payable_amount: discount})
    invoice.tax_totals = [new_tax_totals]
    invoice.legal_monetary_total = invoice.total_tax_totals + taxable_total.payable_amount

    generate_documents(invoice, pdf)
    invoice
  end

  def with_isc(pdf=false)
    invoice_data = data(@items - 1)
    invoice_data[:lines] << {id: @items.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 13500, price: 10000, 
                             item: {id: @items.to_s, description: "Item #{@items}"}, tax_totals: [{amount: 1800, type: :igv}, {amount: 1700, type: :isc}]}
    invoice = document_class.new(invoice_data)
    
    taxable_total = invoice.get_monetary_total_by_id("1001")
    taxable_total.payable_amount = taxable_total.payable_amount.value + 10000
    invoice.modify_monetary_total(taxable_total)

    invoice.legal_monetary_total.value = invoice.legal_monetary_total.value + 13500
    
    new_tax_totals = [{amount: invoice.total_tax_totals + SUNAT::PaymentAmount.new(1800), type: :igv}, {amount: 1700, type: :isc}]
    invoice.tax_totals = new_tax_totals

    generate_documents(invoice, pdf)
    invoice
  end

  def with_reception(pdf=false)
    invoice = document_class.new(data(@items))
    payable_amount = (invoice.legal_monetary_total.value * 0.02).round
    invoice.add_additional_monetary_total({id: "2001", reference_amount: invoice.legal_monetary_total, payable_amount: payable_amount, total_amount: invoice.legal_monetary_total.value + payable_amount})
    invoice.add_additional_property({id: "2000", value: "COMPROBANTE PERCEPCION"})
    generate_documents(invoice, pdf)
    invoice
  end

  def with_different_currency(pdf=false)
    invoice = document_class.new(data(@items, 'EUR'))
    generate_documents(invoice, pdf)
    invoice
  end
  
  protected

  def document_class
    SUNAT::Invoice
  end

  protected
    def customer
      {legal_name: "BEYOND MOBILE SOFTWARE S.A.C.", ruc: "20548902143"}
    end

  private
    def data(items = 0, currency = 'PEN')
      invoice_data = {id: "#{@serie}-#{"%03d" % @@document_serial_id}", customer: customer, 
                    tax_totals: [{amount: {value: items*1800, currency: currency}, type: :igv}], legal_monetary_total: {value: 11800 * items, currency: currency}, 
                    additional_monetary_totals: [{id: "1001", payable_amount: {value: 10000 * items, currency: currency}}]}
      @@document_serial_id += 1
      invoice_data[:lines] = []
      if items > 0
        invoice_data[:lines] = (1..items).map do |item|
          {id: item.to_s, quantity: 1, line_extension_amount: {value: 10000, currency: currency}, pricing_reference: {alternative_condition_price: {price_amount: {value: 11800, currency: currency}}}, 
           price: {value: 10000, currency: currency}, tax_totals: [{amount: {value: 1800, currency: currency}, type: :igv}], 
           item: {id: item.to_s, description: "Item #{item}"}}
        end
      end
      invoice_data
    end
end