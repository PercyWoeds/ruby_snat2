module SUNAT

  # The AccountingSupplierParty contains the basic details of the supplier of
  # the current invoice being generated.
  #
  # Rather then being forced to use the complex XML structure, helper attributes
  # can be provided to quickly generate a usable object. If necessary, attributes
  # will be forwarded to a party object. The following fields are supported: 
  #
  # Basic fields:
  #
  #  * name - name of the company
  #  * ruc  - Peruvian SUNAT ID
  #  * or dni - National ID number, for exports
  # 
  # Address fields:
  #
  #  * address_id - Geographical location (UBIGEO) or post code, eg. "070101"
  #  * street - eg. "Calle Los Olivos 234"
  #  * zone - Urbanization o Zone, eg. "Callao"
  #  * city - eg. "Lima"
  #  * province
  #  * district - eg. "Callao"
  #  * country - use 2 digit identification code, like 'PE' or 'ES'
  #

  class AccountingSupplierParty
    include Model

    RUC_DOCUMENT_CODE = "6"
    DNI_DOCUMENT_CODE = "1"
    
    property :account_id,             String
    property :additional_account_id,  String, :default => RUC_DOCUMENT_CODE
    property :party,                  Party
    
    validates :account_id, existence: true, presence: true, ruc_document: true
    validates :additional_account_id, existence: true, document_type_code: true

    def initialize(*attrs)
      super(parse_attributes(*attrs))
    end
    
    def build_xml(xml)
      xml['cac'].AccountingSupplierParty do
        build_xml_payload(xml)
      end
    end

    protected

    def build_xml_payload(xml)
      # IMPORTANT: We don't know how to handle the case
      # when there is no dni. We are assuming that, because
      # sunat said that the fields are required, the the dni
      # field must be empty string when nil.
      xml['cbc'].CustomerAssignedAccountID  (account_id || '')
      xml['cbc'].AdditionalAccountID        additional_account_id
      
      party.build_xml xml
    end

    def parse_attributes(attrs = {})
      # Perform basic id and name handling
      ruc         = attrs.delete(:ruc)
      dni         = attrs.delete(:dni)
      legal_name  = attrs.delete(:legal_name)
      name        = attrs.delete(:name) || attrs.delete(:legal_name)

      if (dni || ruc)
        # Special case! Try set the properties accordingly.
        self.additional_account_id = dni ? DNI_DOCUMENT_CODE : RUC_DOCUMENT_CODE
        self.account_id = dni || ruc
      end
      
      self.party = {party_legal_entity: {registration_name: legal_name}, name: name}
      
      # Grab or build new party
      self.party ||= (attrs.delete(:party) || {})

      # Then try set the details
      addr_keys = [:address_id, :street, :zone, :city, :province, :district, :country]
      if party.postal_addresses.empty? && !(attrs.keys & addr_keys).empty?
        pa = PostalAddress.new({
          :id                    => attrs.delete(:address_id),
          :street_name           => attrs.delete(:street),
          :city_subdivision_name => attrs.delete(:zone),
          :city_name             => attrs.delete(:city),
          :country_subentity     => attrs.delete(:province),
          :district              => attrs.delete(:district),
        })
        if attrs.has_key?(:country)
          pa.country = {
            :identification_code => attrs.delete(:country)
          }
        end
        party.postal_addresses << pa
      end

      attrs
    end
  end
end
