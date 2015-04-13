require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator
  def document_class
    SUNAT::Receipt
  end
end