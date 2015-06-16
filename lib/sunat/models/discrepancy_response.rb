module SUNAT
  class DiscrepancyResponse
    include Model

    property :reference_id,  String
    property :response_code, String
    property :description,   String

    validates :reference_id, presence: true
    validates :description, presence: true

    def build_xml(xml)
      xml['cac'].DiscrepancyResponse do
        xml['cbc'].ReferenceID reference_id
        xml['cbc'].ResponseCode response_code
        xml['cbc'].Description description
      end
    end

  end
end
