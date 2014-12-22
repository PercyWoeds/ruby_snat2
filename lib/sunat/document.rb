# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model

    DEFAULT_CUSTOMIZATION_ID = "1.0"

    property :id,                         String # Usually: serial + correlative number
    property :issue_date,                 Date
    property :reference_date,             Date
    property :customization_id,           String
    property :document_type_name,         String
    property :accounting_supplier_party,  AccountingSupplierParty
    property :additional_properties,      [AdditionalProperty]
    property :additional_monetary_totals, [AdditionalMonetaryTotal]
    property :address,                    String

    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end

    def initialize(*args)
      super(*args)
      self.issue_date ||= Date.today
      self.reference_date ||= Date.today
      self.additional_properties ||= []
      self.additional_monetary_totals ||= []
    end

    def accounting_supplier_party
      get_attribute(:accounting_supplier_party) || AccountingSupplierParty.new(SUNAT::SUPPLIER.as_hash)
    end

    def file_name
      raise "Implement in child document"
    end

    def address
      get_attribute(:address) || "#{supplier.street}, #{supplier.district} (#{supplier.city})"
    end

    def operation_list
      raise "Implement in child document"
    end

    def operation
      raise "Implement in child document"
    end

    def build_pdf_header(pdf)
      pdf.text "Cabify", :size => 40,
                         :style => :bold
      pdf.text "#{address}", :size => 16,
                         :style => :bold
      pdf.bounding_box([325, 725], :width => 200, :height => 70) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C #{self.ruc}", :align => :center
          pdf.text "#{self.document_type_name.upcase}", :align => :center
          pdf.text "#{self.id}", :align => :center,
                                 :style => :bold
        end
      end
      pdf.move_down 25
      pdf
    end

    def build_pdf_header_extension(pdf)
      raise "Implement in child document"
    end

    def build_pdf_body(pdf)
      raise "Implement in child document"
    end

    def build_pdf_footer(pdf)
      pdf.bounding_box([0, 50], :width => 535, :height => 50) do
        pdf.stroke_bounds
        pdf.text "#{self.legal_name}", :align => :center,
                                       :valign => :center,
                                       :style => :bold
      end
      pdf
    end

    def build_pdf
      Prawn::Document.generate("pdf_output/#{file_name}.pdf") do |pdf|
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        build_pdf_footer(pdf)
      end
    end

    def to_pdf
      build_pdf
    end


    def customization_id
      self['customization_id'] ||= DEFAULT_CUSTOMIZATION_ID
    end

    def add_additional_property(options)
      id = options[:id]
      name = options[:name]
      value = options[:value]

      self.additional_properties << AdditionalProperty.new.tap do |property|
        property.id = id        if id
        property.name = name    if name
        property.value = value  if value
      end
    end

    # The signature here is for two reasons:
    #   1. easy call of the global SUNAT::SIGNATURE
    #   2. possible dependency injection of a signature in a test vía stubs
    #
    attr_accessor :signature

    def signature
      @signature ||= SUNAT::SIGNATURE
    end

    def supplier
      @supplier ||= SUNAT::SUPPLIER
    end

    def to_xml
      # We create a decorator responsible to build the xml in top
      # of this document
      xml_document = XMLDocument.new(self)

       # Pass control over to the xml builder
      res = xml_document.build_xml do |xml|
        build_xml(xml)
      end

      # We pass a decorator to xml_signer, to allow it to use some generators
      # of xml_document
      xml_signer = XMLSigner.new(xml_document)
      xml_signer.sign(res.to_xml)
    end

    def build_xml(xml)
      raise "This method must be overriden!"
    end

    # returns a savon response (an httpi response)
    def deliver!
      sender = Delivery::Sender.new(file_name, to_zip, operation)
      sender.call
    end

    def to_zip
      @zip ||= Delivery::Chef.new(file_name + ".xml", to_xml).prepare
    end
  end
end
