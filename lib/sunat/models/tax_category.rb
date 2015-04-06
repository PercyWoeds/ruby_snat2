# encoding: UTF-8

module SUNAT
  class TaxCategory
    include Model
    
    property :tax_exemption_reason_code,  String
    property :tier_range,                 String
    property :tax_scheme,                 TaxScheme
    
    validates :tax_exemption_reason_code, inclusion: { in: ANNEX::CATALOG_07 }, :allow_nil => true
    validates :tier_range, inclusion: { in: ANNEX::CATALOG_08 }, :allow_nil => true
    
    def build_xml(xml)
      xml['cac'].TaxCategory do        
        xml['cbc'].TaxExemptionReasonCode(tax_exemption_reason_code) if tax_exemption_reason_code
        xml['cbc'].TierRange(tier_range) if tier_range
      
        tax_scheme.build_xml(xml)
      end
    end
  end
end
