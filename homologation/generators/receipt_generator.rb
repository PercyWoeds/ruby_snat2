require_relative 'document_generator'

class ReceiptGenerator < InvoiceGenerator

  def customer
    {legal_name: "ANA PATRICIA", dni: "70025425-8"}
  end

  def document_class
    SUNAT::Receipt
  end
end