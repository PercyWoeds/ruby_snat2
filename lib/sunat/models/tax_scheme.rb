module SUNAT
  class TaxScheme
    include Model
    
    property :id,               String # id of the tax in sunat's catalog
    property :name,             String # name of the tax
    property :type,             Symbol
    property :tax_type_code,    String
    
    validates :tax_type_code, tax_type_code: true
    
    TAXES = {
      :igv => { id: "1000", name: "IGV", tax_type_code: "VAT" },
      :isc => { id: "2000", name: "ISC", tax_type_code: "EXC" },
      :other => { id: "9999", name: "OTROS", tax_type_code: "OTH" }
    }

    def initialize(*attrs)
      super(parse_attributes(*attrs))
    end
   
    def build_xml(xml)
      xml['cac'].TaxScheme do
        xml['cbc'].ID           id
        xml['cbc'].Name         name
        xml['cbc'].TaxTypeCode  tax_type_code
      end
    end

    protected

    def parse_attributes(attrs = {})
      if attrs.is_a?(Symbol)
        type = attrs
        attrs = TAXES[attrs]
        attrs[:type] = type
      end
      attrs
    end

  end
end
