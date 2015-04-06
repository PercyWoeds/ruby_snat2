module SUNAT
  class XMLSigner < SimpleDelegator
    
    C14N_ALGORITHM            = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
    DIGEST_ALGORITHM          = "http://www.w3.org/2000/09/xmldsig#sha1"
    SIGNATURE_ALGORITHM       = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
    TRANSFORMATION_ALGORITHM  = "http://www.w3.org/2000/09/xmldsig#enveloped- signature"
    
    # decorator for XMLDocuments
    def sign(xml_string)
      digested_document = digest_for(xml_string)
      document          = build_from_xml(xml_string)
      
      search_signature_location(document) do |signature_location|
        # We built a basic_builder to get the namespaces
        # and use build_signature_extension as we were inside a builder
        doc = make_basic_builder do |xml|
          build_signature_extension xml, digested_document
        end.doc
        
        signature = doc.xpath("//ds:Signature")
        signature_location.add_child(signature)
      end
      
      document.to_xml
    end
    
    private
    
    def search_signature_location(document, &block)
      element = document.xpath("//ext:ExtensionContent[not(node())]", 'ext' => XMLDocument::EXT_NAMESPACE).first
      if element.present?
        block.call(element)
      else
        warn 'there is not an empty ExtensionContent to put the signature'
      end
    end
    
    def build_signature_extension(xml, digested_document)
      xml['ds'].Signature(Id: signature.id) do
        build_signature_signed_info xml, digested_document
        build_signature_value       xml
        build_signature_key_info    xml
      end
    end

    def build_signature_signed_info(xml, digested_document)
      xml['ds'].SignedInfo do
        xml['ds'].CanonicalizationMethod(Algorithm: C14N_ALGORITHM)
        xml['ds'].SignatureMethod(Algorithm: SIGNATURE_ALGORITHM)
        xml['ds'].Reference(URI: "") do
          xml['ds'].Transforms do
            xml['ds'].Transform(Algorithm: TRANSFORMATION_ALGORITHM)
          end
          xml['ds'].DigestMethod(Algorithm: DIGEST_ALGORITHM)
          xml['ds'].DigestValue(digested_document)
        end
      end
    end

    def build_signature_value(xml)
      find_signed_info(xml.doc) do |signed_info|
        canon = canonicalize(signed_info)
        xml['ds'].SignatureValue signature_for(canon)
      end
    end

    def build_signature_key_info(xml)
      xml['ds'].KeyInfo do
        xml['ds'].X509Data do
          certificate = signature.certificate
          xml['ds'].X509SubjectName certificate.issuer
          xml['ds'].X509Certificate certificate.cert
        end
      end
    end

    def find_signed_info(doc, &block)
      # Prepare the SignedInfo for the signature
      signed_info = doc.xpath('//ds:SignedInfo').first
      if signed_info.present?
        block.call(signed_info)
      else
        warn 'there is no SignedInfo in this xml to put the signature.'
      end
    end

    def canonicalize(signed_info)
      signed_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ['soap', 'web'])
    end

    def signature_for(text)
      signature.signature_for(text)
    end

    def digest_for(text)
      OpenSSL::Digest::SHA1.new.base64digest(text)
    end
  end
end