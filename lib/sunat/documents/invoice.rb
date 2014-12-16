module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    
    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    
    ID_FORMAT = /F[A-Z\d]{3}-\d{1,8}/

    include HasTaxTotals

    xml_root :Invoice

    property :invoice_type_code,               String
    property :document_currency_code,          String, :default => "PEN"
    property :customer,                        AccountingCustomerParty
    property :lines,                           [InvoiceLine]
    property :tax_totals,                      [TaxTotal]
    property :legal_monetary_total,            PaymentAmount
    property :despatch_document_references,    [ReferralGuideline] # Spanish: Guías de remisión
    property :additional_document_references,  [DocumentReference]
    property :ruc,                             String
    property :legal_name,                      String		

		validates :id, presence:true, format: { with: Proc.new{ self.class::ID_FORMAT } }
    validates :document_currency_code, existence: true, currency_code: true
    validates :invoice_type_code, tax_document_type_code: true

    def initialize(*args)
      self.lines ||= []
      self.invoice_type_code ||= self.class::DOCUMENT_TYPE_CODE
      self.tax_totals ||= []
      self.despatch_document_references ||= []
      self.additional_document_references ||= []
      super(*args)
    end
    
    def file_name
      document_type_code = self.class::DOCUMENT_TYPE_CODE
      "#{ruc}-#{document_type_code}-#{id}"
    end
    
    def operation
      :send_bill
    end
    
    def add_line(&block)
      line = InvoiceLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

    def build_own_xml(xml)
      xml['cbc'].InvoiceTypeCode      invoice_type_code
    end

    def build_xml(xml)
      build_own_xml xml
      xml['cbc'].DocumentCurrencyCode document_currency_code
      
      accounting_supplier_party.build_xml xml
      
      # sunat says if no customer exists, we must use a dash
      if customer.present?
        customer.build_xml xml
      else
        xml['cac'].AccountingCustomerParty "-"
      end
      
      tax_totals.each do |total|
        total.build_xml xml
      end

      xml['cac'].LegalMonetaryTotal do
        legal_monetary_total.build_xml xml, :PayableAmount
      end if legal_monetary_total.present?
      
      lines.each do |line|
        line.build_xml xml
      end

      build_xml_for_additional_totals(xml)      
    end

    protected

    def build_xml_for_additional_totals(xml)
      if additional_monetary_totals.length > 0
        xml['ext'].UBLExtension do
          xml['ext'].ExtensionContent do
            xml['sac'].AdditionalInformation do
              additional_monetary_totals.each do |amt|
                amt.build_xml(xml)
              end
            end
          end
        end
      end
    end
    
    private
    
    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end


  end
end
