module SUNAT
  class BasicLine
    include Model

    property :line_id,            String
    property :document_serial_id, String
    property :document_type_code, String

    [:line_id, :document_serial_id].each do |field|
      validates field, existence: true, presence: true
    end
    validates :document_type_code, existence: true, presence: true, tax_document_type_code: true

    TABLE_HEADERS = ["ITEM"]

    def self.pdf_row_headers
      TABLE_HEADERS
    end

    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end

    def initialize(*args)
      super(*args)
      self.document_type_code ||= document_code
    end

    def document_code
      SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end

    def build_pdf_table_row(pdf)
      row = []
      row << self.line_id
      row
    end

    def build_base_xml(xml, &block)
      xml['sac'].send(xml_root) do
        xml['cbc'].LineID                 line_id
        xml['cbc'].DocumentTypeCode       document_type_code
        xml['sac'].DocumentSerialID       document_serial_id
        yield(xml)
      end
    end
  end
end