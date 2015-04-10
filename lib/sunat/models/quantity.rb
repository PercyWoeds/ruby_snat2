module SUNAT
  
  class Quantity
    include Model
    
    property :quantity,   Fixnum
    property :unit_code,  String, default: "NIU" # unit codes as defined in UN/ECE rec 20
    
    def build_xml(xml, tag_name)
      xml['cbc'].send(tag_name, { unitCode: unit_code }, quantity)
    end
  end
end