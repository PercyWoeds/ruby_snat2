module SUNAT
  class VoidedDocuments < Document

  	xml_root :VoidedDocuments

  	property :lines, [VoidedDocumentsLine]

  	 def initialize(*args)
      super(*args)
      self.lines  ||= []
      self.document_type_name ||= "Comunicacion de baja"
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
  end
end