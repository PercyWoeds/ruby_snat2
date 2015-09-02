module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #

  class BasicInvoice < Document

    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    DEFAULT_CURRENCY_CODE = 'PEN'

    include HasTaxTotals

    property :invoice_type_code,               String
    property :document_currency_code,          String
    property :customer,                        AccountingCustomerParty
    property :lines,                           [InvoiceLine]
    property :tax_totals,                      [TaxTotal]
    property :legal_monetary_total,            PaymentAmount
    property :despatch_document_references,    [ReferralGuideline] # Spanish: Guías de remisión

    validate :id_valid?
    validates :id, presence: true
    validates :document_currency_code, existence: true, currency_code: true
    validates :invoice_type_code, tax_document_type_code: true
    validates :customer, presence: true
    validates :legal_monetary_total, existence: true

    def initialize(*args)
      self.lines ||= []
      self.invoice_type_code ||= self.class::DOCUMENT_TYPE_CODE
      self.tax_totals ||= []
      self.despatch_document_references ||= []
      self.document_type_name ||= "Factura Electronica"
      self.customer ||= AccountingCustomerParty.new({
        account_id: '-',
        additional_account_id: '-'
      })

      super(*args)
    end

    def document_currency_code
      currency = get_attribute(:document_currency_code)
      if currency
        currency
      elsif legal_monetary_total
        legal_monetary_total.currency
      else
        DEFAULT_CURRENCY_CODE
      end
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

    def total_tax_totals
      total = PaymentAmount.new(value:0, currency: document_currency_code)
      tax_totals.each {|tax_total| total = total + tax_total.tax_amount}
      total
    end

    def add_line(&block)
      line = InvoiceLine.new.tap(&block)
      line.id = get_line_number.to_s
      self.lines << line
    end

    def build_pdf_body(pdf)
      pdf.font "Helvetica", :size => 8

      max_rows = [client_data_headers.length, invoice_headers.length, 0].max
      rows = []
      (1..max_rows).each do |row|
        rows_index = row - 1
        rows[rows_index] = []
        rows[rows_index] += (client_data_headers.length >= row ? client_data_headers[rows_index] : ['',''])
        rows[rows_index] += (invoice_headers.length >= row ? invoice_headers[rows_index] : ['',''])
      end

      if rows.present?

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

      result = pdf.table table_content, :position => :center,
                                        :header => true,
                                        :width => pdf.bounds.width
      pdf.move_down 10

      pdf.table invoice_summary, {
        :position => :right,
        :cell_style => {:border_width => 1},
        :width => pdf.bounds.width/2
      } do
        columns([0]).font_style = :bold
      end

      pdf

    end

    def build_xml(xml)
      xml['cbc'].IssueDate format_date(self.issue_date)
    end

    def deliver!
      sender.submit_file(file_name, to_zip)
    end

    private

    def client_data_headers
      client_headers = [["Cliente", customer.party.party_legal_entity.registration_name]]
      client_headers << ["Direccion", customer.party.postal_addresses.first.to_s]
      client_headers << [customer.type_as_text, customer.account_id]
      client_headers
    end

    def invoice_headers
      invoice_headers = [["Fecha de emision", issue_date]]
      invoice_headers << ["Tipo de moneda", Currency.new(document_currency_code).singular_name.upcase]
      invoice_headers
    end

    def invoice_summary
      invoice_summary = []
      monetary_totals = [{label: "Operaciones gravadas", catalog_index: 0},
       {label: "Operaciones inafectas", catalog_index: 1},
       {label: "Operaciones exoneradas", catalog_index: 2},
       {label: "Operaciones gratuitas", catalog_index: 3},
       {label: "Sub total", catalog_index: 4},
       {label: "Total descuentos", catalog_index: 9}
      ]
      monetary_totals.each do |monetary_total|
        value = get_monetary_total_by_id(SUNAT::ANNEX::CATALOG_14[monetary_total[:catalog_index]])
        if value.present?
          invoice_summary << [monetary_total[:label], value.payable_amount.to_s]
        end
      end

      tax_totals.each do |tax_total|
        invoice_summary << [tax_total.tax_type_name, tax_total.tax_amount.to_s]
      end

      invoice_summary << ["Total", legal_monetary_total.to_s]
      if get_additional_property_by_id(SUNAT::ANNEX::CATALOG_15[0])
        total = get_additional_property_by_id(SUNAT::ANNEX::CATALOG_15[0]).value
      else
        total = legal_monetary_total.textify.upcase
      end
      invoice_summary << ["Monto del total", total]
      invoice_summary
    end

    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end

  end
end
