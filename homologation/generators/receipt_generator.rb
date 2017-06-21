require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator

  def customer
    {legal_name: "NICOLAS SAAVEDRA ROMAN", dni: "26731111"}
  end

  def document_class
    SUNAT::Receipt
  end
end