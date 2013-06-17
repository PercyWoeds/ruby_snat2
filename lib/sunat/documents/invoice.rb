module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    extend PaymentDocument
    
    # All the invoice structure is identical
    # to the paystub's one. All the structure
    # is inherited from PaymentDocument
    
    def to_xml
      xml_builder.get_xml
    end
    
    def xml_builder
      @xml_builder ||= XMLBuilders::InvoiceBuilder.new(self)
    end
  end
end