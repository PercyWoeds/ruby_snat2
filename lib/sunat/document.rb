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
    property :company_logo_path,          String
    property :company_name,               String
    property :document_type_name,         String
    property :accounting_supplier_party,  AccountingSupplierParty
    property :additional_properties,      [AdditionalProperty]
    property :additional_monetary_totals, [AdditionalMonetaryTotal]
    property :address,                    String
    property :pdf_path,                 String

    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end

    def not_implemented_exception
      "Implement in child document"
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
      raise not_implemented_exception
    end

    def address
      get_attribute(:address) || "#{supplier.street}, #{supplier.district} (#{supplier.city})"
    end

    def operation_list
      raise not_implemented_exception
    end

    def operation
      raise not_implemented_exception
    end

    def build_pdf_header(pdf)
      if self.company_logo_path.nil?
        pdf.text "#{self.company_name}", :size => 40,
                                         :style => :bold
      else
        pdf.image "#{self.company_logo_path}", :width => 200
      end
      pdf.move_down 4
      pdf.text "#{address}", :size => 12,
                         :style => :bold
      pdf.bounding_box([325, 725], :width => 200, :height => 70) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C #{self.accounting_supplier_party.account_id}", :align => :center
          pdf.text "#{self.document_type_name.upcase}", :align => :center
          pdf.text "#{self.id}", :align => :center,
                                 :style => :bold
        end
      end
      pdf.move_down 25
      pdf
    end

    def build_pdf_header_extension(pdf)
      raise not_implemented_exception
    end

    def build_pdf_body(pdf)
      raise not_implemented_exception
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

    def build_pdf(path=false)
      Prawn::Document.generate(path || self.pdf_path || "pdf_output/#{file_name}.pdf") do |pdf|
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

    def get_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] == value)
          results.push ap
        end
      end
      results
    end

    def get_additional_property_by_id(id)
      get_additional_properties_by_property(:id, id)[0]
    end

    def remove_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] != value)
          results.push ap
        end
      end
      self.additional_properties = results
      results
    end

    def modify_additional_property_by_id(ap)
      remove_additional_properties_by_property(:id, ap[:id])
      add_additional_property ap
    end

    def add_additional_monetary_total(options)
      id = options[:id]
      payable_amount = options[:payable_amount]
      reference_amount = options[:reference_amount]
      total_amount = options[:total_amount]
      percent = options[:percent]

      self.additional_monetary_totals << AdditionalMonetaryTotal.new.tap do |amt|
        amt.id = id                             if id
        amt.payable_amount = payable_amount     if payable_amount
        amt.reference_amount = reference_amount if reference_amount
        amt.total_amount = total_amount         if total_amount
        amt.percent = percent                   if percent
      end
    end

    def get_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] == value)
          results.push amt
        end
      end
      results
    end

    def get_monetary_total_by_id(id)
      get_monetary_totals_by_property(:id, id)[0]
    end

    def remove_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] != value)
          results.push amt
        end
      end
      self.additional_monetary_totals = results
      results
    end

    def modify_monetary_total_by_id(amt)
      remove_monetary_totals_by_property(:id, amt[:id])
      add_additional_monetary_total amt
    end

    # The signature here is for two reasons:
    #   1. easy call of the global SUNAT::SIGNATURE
    #   2. possible dependency injection of a signature in a test via stubs
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
