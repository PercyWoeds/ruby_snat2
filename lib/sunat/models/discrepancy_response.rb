module SUNAT
  class DiscrepancyResponse
    include Model

    RESPONSE_CODES = [
      '01', # Interes por mora
      '02'  # Aumento en el valor
    ]

    property :reference_id,  String
    property :response_code, String, :default => '01'
    property :description,   String

    validates :response_code, :inclusion => {:in => RESPONSE_CODES} 

    def build_xml(xml)
      xml['cac'].DiscrepancyResponse do
        xml['cbc'].ReferenceID reference_id
        xml['cbc'].ResponseCode response_code
        xml['cbc'].Description description
      end
    end

  end
end
