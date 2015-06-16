module SUNAT
  class VoidedDocuments < Document

    SUMMARY_TYPE = 'RA'
    
  	xml_root :VoidedDocuments

  	property :lines, [VoidedDocumentsLine]
    property :correlative_number,   String
    property :reference_date,       Date

    validates :correlative_number, presence: true
    validates :lines, presence: true

  	 def initialize(*args)
      super(*args)
      self.lines  ||= []
      self.document_type_name ||= "Comunicacion de baja"
      self.reference_date ||= Date.today
    end

    def document_namespace
      'urn:sunat:names:specification:ubl:peru:schema:xsd:VoidedDocuments-1'
    end

    def operation
      :send_summary
    end

  	def add_line(&block)
      line = VoidedDocumentsLine.new.tap(&block)
      line.line_id = get_line_number.to_s
      self.lines << line
    end

    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end

  	def build_xml(xml)
      xml['cbc'].ReferenceDate format_date(self.reference_date) if reference_date.present?
      xml['cbc'].IssueDate format_date(self.issue_date)
      signature.xml_metadata xml
      accounting_supplier_party.build_xml xml
      lines.each do |line|
        line.build_xml xml
      end
  	end

    def file_name
      "#{accounting_supplier_party.account_id}-#{id}"
    end

    def build_pdf_body(pdf)
      rows = header_rows

      if rows.present?

        pdf.table(rows, {
          :position => :center,
          :cell_style => {:border_width => 0},
          :width => pdf.bounds.width
        }) do 
          columns([0]).font_style = :bold
        end

        pdf.move_down 20

      end
      table_content = [VoidedDocumentsLine.pdf_row_headers]
      
      lines.each do |line|
        table_content << line.build_pdf_table_row(pdf)
      end

      pdf.table table_content, :position => :center
      pdf
    end
    
    def header_rows
      rows = [["Fecha de emision de los documentos", reference_date]]
      rows << ["Fecha de generacion del resumen", issue_date]
      rows 
    end

    def deliver!
      sender.submit_summary(file_name, to_zip)
    end

    def self.generate_id(issue_date, correlative_number)
      formatted_issue_date = issue_date.strftime("%Y%m%d")
      "RA-#{formatted_issue_date}-#{correlative_number}"
    end

  end
end