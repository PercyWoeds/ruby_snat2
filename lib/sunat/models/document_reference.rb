module SUNAT
  
  class DocumentReference
    include Model
    
    property :document_type_code, String
    property :id,                 String
    
    validates :document_type_code, tax_document_type_code: true
    validates :id, presence: true

    def build_xml(xml)
      xml['cbc'].ID id
      xml['cbc'].DocumentTypeCode document_type_code
    end
  end
end