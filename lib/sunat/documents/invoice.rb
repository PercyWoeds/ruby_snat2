module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    
    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    
    ID_FORMAT = /\AF[A-Z\d]{3}-\d{1,8}\Z/

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
    property :legal_name,                      String

    property :client_data,                     Array
    property :invoice_summary,                 Array

    validate :id_valid?
    validates :id, presence:true
    validates :document_currency_code, existence: true, currency_code: true
    validates :invoice_type_code, tax_document_type_code: true

    def initialize(*args)
      self.lines ||= []
      self.invoice_type_code ||= self.class::DOCUMENT_TYPE_CODE
      self.tax_totals ||= []
      self.despatch_document_references ||= []
      self.additional_document_references ||= []
      self.document_type_name ||= "Factura Electronica"
      self.client_data ||= []
      self.invoice_summary ||= []
      super(*args)
    end
    
    def id_valid?
      valid = (self.class::ID_FORMAT =~ self.id) == 0
      if !valid
        errors.add(:id, "doesn't match regexp #{self.class::ID_FORMAT}")
      end
    end

    def file_name
      document_type_code = self.class::DOCUMENT_TYPE_CODE
      "#{accounting_supplier_party.account_id}-#{document_type_code}-#{id}"
    end
    
    def operation
      :send_bill
    end

    def total_price
      operation = 0
      lines.each do |line|
        operation += line.total_price
      end
      SUNAT::PaymentAmount.new(operation)
    end

    def total_alternave_condition_price_amount
      operation = 0
      lines.each do |line|
        operation += line.total_alternave_condition_price_amount
      end
      SUNAT::PaymentAmount.new(operation)
    end

    def total_extension_amount
      operation = 0
      lines.each do |line|
        operation += line.line_extension_amount.value
      end
      SUNAT::PaymentAmount.new(operation)
    end

    def total_tax_totals
      total = 0

      if self.lines.count
        self.lines.each do |line|
          total += line.calculate_tax_total
        end
      end

      total
    end

    def total_sub_totals
      subtotal = 0

      if self.lines.count
        self.lines.each do |line|
          subtotal += line.calculate_tax_sub_total
        end
      end

      subtotal
    end

    def calculated_tax_totals
      totals = []

      if self.lines.count
        self.lines.each do |line|
          totals.push line.calculate_tax_total * line.quantity.quantity
        end
      end

      totals
    end
    
    def add_line(&block)
      line = InvoiceLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

    def build_pdf_body(pdf)
      pdf.font "Helvetica", :size => 8
      
      rows = client_data

      if rows.count

        table_middle = rows.count/2

        (0..(table_middle-1)).each do |i|
          rows[i] += rows.delete_at table_middle
        end

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do 
          columns([0, 2]).font_style = :bold
        end

        pdf.move_down 20

      end

      headers = []
      table_content = []
      
      InvoiceLine::TABLE_HEADERS.each do |header|
        cell = pdf.make_cell(:content => header)
        cell.background_color = "FFFFCC"
        headers << cell
      end

      table_content << headers
      
      lines.each do |line|
        table_content << line.build_pdf_table_row(pdf)
      end

      pdf.table table_content, :position => :center,
                               :header => true

      pdf.move_down 10

      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width/2
      } do 
        columns([0, 2]).font_style = :bold
      end

      pdf

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
    end

    private
    
    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end


  end
end
