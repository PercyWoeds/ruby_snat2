module SUNAT
  # decorator for Documents
  class XMLDocument < SimpleDelegator

    DS_NAMESPACE        = 'http://www.w3.org/2000/09/xmldsig#'
    CAC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
    CBC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
    EXT_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'
    SAC_NAMESPACE       = 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'
    CCTS_NAMESPACE      = 'urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2'
    QDT_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2'
    STAT_NAMESPACE      = 'urn:oasis:names:specification:ubl:schema:xsd:DocumentStatusCode-1.0'
    UDT_NAMESPACE       = 'urn:un:unece:uncefact:data:draft:UnqualifiedDataTypesSchemaModule:2'
    XSI_NAMESPACE       = 'http://www.w3.org/2001/XMLSchema-instance'
    
    CUSTOMIZATION_ID = "1.0"
    UBL_VERSION_ID = "2.0"
    
    def build_xml(&block)
      make_basic_builder do |xml|
        build_ubl_extensions xml
        build_general_data xml
        block.call xml unless block.nil?
      end
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
    
    def declaration
      @_declaration ||= '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
    end
    
    def build_root(xml, &block)
      attributes = {
        'xmlns'               => document_namespace,
        'xmlns:cac'           => CAC_NAMESPACE,
        'xmlns:cbc'           => CBC_NAMESPACE,
        'xmlns:ccts'          => CCTS_NAMESPACE,
        'xmlns:ds'            => DS_NAMESPACE,
        'xmlns:ext'           => EXT_NAMESPACE,
        'xmlns:qdt'           => QDT_NAMESPACE,
        'xmlns:sac'           => SAC_NAMESPACE,
        'xmlns:stat'          => STAT_NAMESPACE,
        'xmlns:udt'           => UDT_NAMESPACE,
        'xmlns:xsi'           => XSI_NAMESPACE
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
    end
    
    def build_ubl_extensions(xml)
      xml['ext'].UBLExtensions do
        build_additional_information_extension xml
        build_signature_placeholder_extension xml
      end
    end
    
    def build_additional_information_extension(xml)

      return if self.additional_monetary_totals.empty?
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
