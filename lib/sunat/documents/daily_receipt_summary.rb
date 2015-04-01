module SUNAT
  #
  # The receipt summary is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  #
  
  class DailyReceiptSummary < Document
    
    SUMMARY_TYPE = 'RC' # Look Sunat's Programmer's manual page 6
    
    xml_root :SummaryDocuments

    property :lines,                [SummaryDocumentsLine]
    property :notes,                [String]
    property :correlative_number,   String

    validates :lines, presence: true
    validates :correlative_number, presence: true
    
    def initialize(*args)
      super(*args)
      self.notes  ||= []
      self.lines  ||= []
      self.id     ||= default_id
      self.document_type_name ||= "Resumenes Diarios"
    end
    
    def operation
      :send_summary
    end
    
    def file_name
      formatted_issue_date = issue_date.strftime("%Y%m%d")
      "#{accounting_supplier_party.account_id}-#{SUMMARY_TYPE}-#{formatted_issue_date}-#{correlative_number}"
    end
    
    def add_line(&block)
      line = SummaryDocumentsLine.new.tap(&block)
      line.line_id ||= get_line_number.to_s
      self.lines << line
    end
    
    def build_xml(xml)
      notes.each do |note|
        xml['cbc'].Note note
      end
      
      lines.each do |line|
        line.build_xml xml
      end
    end
    
    private
    
    def default_id
      plain_date = reference_date.strftime("%Y%m%d")
      "RC-#{plain_date}"
    end
    
    def get_line_number
      @current_line_number ||= 0
      @current_line_number += 1
      @current_line_number
    end

    def build_pdf_body(pdf)

      table_content = [SummaryDocumentsLine.pdf_row_headers]
      
      lines.each do |line|
        table_content << line.build_pdf_table_row(pdf)
      end

      pdf.table table_content, :position => :center
      pdf
    end
    
  end
end
