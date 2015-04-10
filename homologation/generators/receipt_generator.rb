require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator
  def self.with_igv(group, group_case, items, serie, pdf=false)
    receipt = SUNAT::Receipt.new(data(serie, items))
    generate_documents(group, group_case, receipt, pdf)
    receipt
  end
end