module SUNAT
  # decorator for Documents
  class XMLDocument < SimpleDelegator
    
    XML_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'
    DS_NAMESPACE        = 'http://www.w3.org/2000/09/xmldsig#'
    CAC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
    CBC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
    EXT_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'
    SAC_NAMESPACE       = 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'
    XSI_NAMESPACE       = 'http://www.w3.org/2001/XMLSchema-instance'
    
    XSI_SCHEMA_LOCATION = 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
        
    DATE_FORMAT = "%Y-%m-%d"
    
    CUSTOMIZATION_ID = "1.0"
    UBL_VERSION_ID = "2.0"
    
    def build_xml(&block)
      make_basic_builder do |xml|
        build_ubl_extensions xml
        build_general_data xml
        signature.xml_metadata xml
        
        block.call xml
      end.to_xml
    end
    
    def build_from_xml(xml)
      Nokogiri::XML(xml)
    end
    
    def make_basic_builder(&block)
      make_builder_from(declaration) do |xml|
        build_root xml, &block
      end
    end
    
    private
    
    def build_extension(xml, &block)
      xml['ext'].UBLExtension do
        xml['ext'].ExtensionContent(&block)
      end
    end
    
    def format_date(date)
      date.strftime(DATE_FORMAT)
    end
    
    def declaration
      @_declaration ||= '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
    end
    
    def build_root(xml, &block)
      attributes = {
        'xmlns'               => XML_NAMESPACE,
        'xmlns:cac'           => CAC_NAMESPACE,
        'xmlns:cbc'           => CBC_NAMESPACE,
        'xmlns:ds'            => DS_NAMESPACE,
        'xmlns:ext'           => EXT_NAMESPACE,
        'xmlns:sac'           => SAC_NAMESPACE,
        'xmlns:xsi'           => XSI_NAMESPACE,
        'xsi:schemaLocation'  => XSI_SCHEMA_LOCATION
      }
      # self.xml_root comes from the document being decorated
      xml.send(self.xml_root, attributes, &block)
    end
    
    def make_builder_from(xml, &block)
      xml_doc = build_from_xml(xml)
      Nokogiri::XML::Builder.with(xml_doc, &block)
    end
    
    def build_general_data(xml)
      xml['cbc'].UBLVersionID         UBL_VERSION_ID
      xml['cbc'].CustomizationID      CUSTOMIZATION_ID
      xml['cbc'].ID                   self.id
      xml['cbc'].IssueDate            format_date(self.issue_date)
    end
    
    def build_ubl_extensions(xml)
      xml['ext'].UBLExtensions do
        build_additional_information_extension xml
        build_signature_placeholder_extension xml
      end
    end
    
    def build_additional_information_extension(xml)
      return if additional_monetary_totals.empty? or additional_monetary_totals.empty?
      
      build_extension xml do
        xml['sac'].AdditionalInformation do                  
          self.additional_monetary_totals.each do |additional_monetary_total|
            additional_monetary_total.build_xml xml
          end
          self.additional_properties.each do |property|
            property.build_xml xml
          end
        end
      end
    end
    
    def build_signature_placeholder_extension(xml)
      build_extension xml
    end
    
  end
end