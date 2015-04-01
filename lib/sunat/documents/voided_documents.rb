module SUNAT
  class VoidedDocuments < Document

    SUMMARY_TYPE = 'RA'

  	xml_root :VoidedDocuments

  	property :lines, [VoidedDocumentsLine]
    property :correlative_number,   String

    validates :correlative_number, presence: true
    validates :lines, presence: true

  	 def initialize(*args)
      super(*args)
      self.lines  ||= []
      self.document_type_name ||= "Comunicacion de baja"
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
      lines.each do |line|
        line.build_xml xml
      end
  	end

    def file_name
      formatted_issue_date = issue_date.strftime("%Y%m%d")
      "#{accounting_supplier_party.account_id}-#{SUMMARY_TYPE}-#{formatted_issue_date}-#{correlative_number}"
    end
  end
end