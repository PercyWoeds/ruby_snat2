require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator
  def with_igv(pdf=false)
    receipt = SUNAT::Receipt.new(data(items))
    generate_documents(receipt, pdf)
    receipt
  end
end