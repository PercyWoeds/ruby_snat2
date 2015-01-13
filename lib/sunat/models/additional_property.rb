module SUNAT
  class AdditionalProperty
    include Model
    
    property :id,     String
    property :name,   String
    property :value,  String
    
    def build_xml(xml)
      xml['sac'].AdditionalProperty do
        xml['cbc'].ID     id
        xml['cbc'].Value  value
        xml['cbc'].Name   name if name
      end
    end
  end
end