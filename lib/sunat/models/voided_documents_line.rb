module SUNAT
  class VoidedDocumentsLine < BasicLine

    xml_root :VoidedDocumentsLine
    
    property :document_number_id, String
    property :void_reason, String

    [:document_number_id, :void_reason].each do |field|
      validates field, existence: true, presence: true
    end

    TABLE_HEADERS = ["DOCUMENTO", "MOTIVO"]

    def self.pdf_row_headers
      headers = super || []
      headers += TABLE_HEADERS
    end

    def build_pdf_table_row(pdf)
      row = super
      row << self.document_number_id
      row << self.void_reason
      row
    end

    def build_xml(xml)
      build_base_xml(xml) do
        xml['sac'].DocumentNumberID document_number_id
        xml['sac'].VoidReasonDescription void_reason
      end
    end
  end
end