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
    property :ruc,                             String
    property :legal_name,                      String

    property :client_data,                     Array

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
      "#{ruc}-#{document_type_code}-#{id}"
    end
    
    def operation
      :send_bill
    end

    def calculate
      modify_additional_property_by_id({
        :id => "1000",
        :value => SUNAT::Helpers.textify(total_price.to_s.to_f).upcase
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[0],
        :payable_amount => SUNAT::PaymentAmount.new(9453000)
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[1],
        :payable_amount => SUNAT::PaymentAmount.new(9453000)
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[2],
        :payable_amount => SUNAT::PaymentAmount.new(9453000)
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[3],
        :payable_amount => SUNAT::PaymentAmount.new(calculate_tax_total)
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[4],
        :payable_amount => SUNAT::PaymentAmount.new(calculate_sub_total)
      })

      modify_monetary_total_by_id({
        :id => SUNAT::ANNEX::CATALOG_14[9],
        :payable_amount => SUNAT::PaymentAmount.new(9453000)
      })

    end

    def total_price
      operation = 0
      lines.each do |line|
        operation += line.price.value * line.quantity.quantity
      end
      SUNAT::PaymentAmount.new(operation)
    end

    def calculate_tax_total
      total = 0

      if self.lines.count
        self.lines.each do |line|
          total += line.calculate_tax_total * line.quantity.quantity
        end
      end

      total
    end

    def calculate_sub_total
      subtotal = 0

      if self.lines.count
        self.lines.each do |line|
          subtotal += line.calculate_tax_sub_total * line.quantity.quantity
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
      
      pdf.move_down 20
      wordified_price = get_additional_property_by_id("1000")
      pdf.text "<b>SON:</b> #{wordified_price.value}",
                :align => :left, :inline_format => true
      pdf.text "TOTAL: #{total_price.to_s}"

      pdf.move_up 25

      pdf.table [
        ["Sub total", get_monetary_total_by_id("1005").payable_amount.to_s],
        ["Operaciones gravadas", get_monetary_total_by_id("1001").payable_amount.to_s],
        ["Operaciones inafectas", get_monetary_total_by_id("1002").payable_amount.to_s],
        ["Operaciones exoneradas", get_monetary_total_by_id("1003").payable_amount.to_s],
        ["Operaciones gratuitas", get_monetary_total_by_id("1004").payable_amount.to_s],
        ["Total descuentos", get_monetary_total_by_id("2005").payable_amount.to_s],
        ["Monto del total", get_additional_property_by_id("1000").value]
      ], {
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
